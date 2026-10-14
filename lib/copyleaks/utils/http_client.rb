#
#  The MIT License(MIT)
#
#  Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
# =
require 'net/http'
require 'openssl'
require 'uri'

module Copyleaks
  # A small, thread-safe pool of persistent (keep-alive) connections to one host.
  #
  # * Each request checks out one started Net::HTTP connection, so two threads never share a socket.
  # * Connections are reused between requests, so a call does not pay a new TCP and TLS handshake.
  # * Requests are never retried automatically (max_retries = 0). A submit that timed out is not
  #   uploaded a second time.
  # * A connection that failed mid-request is closed and dropped, never reused.
  # * After a fork, the child process opens its own connections instead of sharing the parent's sockets.
  class HttpClient
    DEFAULT_OPEN_TIMEOUT = 10
    DEFAULT_READ_TIMEOUT = 120
    DEFAULT_WRITE_TIMEOUT = 120
    DEFAULT_KEEP_ALIVE_TIMEOUT = 30
    DEFAULT_POOL_SIZE = 5

    attr_reader :address, :port, :use_ssl, :open_timeout, :read_timeout, :write_timeout,
                :keep_alive_timeout, :pool_size

    # @param [String, URI] uri Base URI of the server, for example 'https://api.copyleaks.com'.
    # @param [Numeric] open_timeout Seconds to wait for the TCP connection and the TLS handshake.
    # @param [Numeric] read_timeout Seconds to wait for each read of the response.
    # @param [Numeric] write_timeout Seconds to wait for each write of the request body.
    # @param [Numeric] keep_alive_timeout Seconds an idle connection is kept before it is reopened.
    # @param [Integer] pool_size Maximum number of open connections. Extra threads wait for a free one.
    def initialize(uri,
                   open_timeout: DEFAULT_OPEN_TIMEOUT,
                   read_timeout: DEFAULT_READ_TIMEOUT,
                   write_timeout: DEFAULT_WRITE_TIMEOUT,
                   keep_alive_timeout: DEFAULT_KEEP_ALIVE_TIMEOUT,
                   pool_size: DEFAULT_POOL_SIZE)
      uri = URI.parse(uri.to_s) unless uri.is_a?(URI::Generic)
      raise ArgumentError, "Copyleaks::HttpClient - uri - invalid server URI: #{uri}" if uri.host.nil?

      { open_timeout: open_timeout, read_timeout: read_timeout, write_timeout: write_timeout,
        keep_alive_timeout: keep_alive_timeout }.each do |name, value|
        unless value.is_a?(Numeric) && value > 0
          raise ArgumentError, "Copyleaks::HttpClient - #{name} - #{name} must be a positive number of seconds"
        end
      end
      unless pool_size.is_a?(Integer) && pool_size > 0
        raise ArgumentError, 'Copyleaks::HttpClient - pool_size - pool_size must be a positive Integer'
      end

      @address = uri.host
      @port = uri.port
      @use_ssl = uri.scheme == 'https'
      @open_timeout = open_timeout
      @read_timeout = read_timeout
      @write_timeout = write_timeout
      @keep_alive_timeout = keep_alive_timeout
      @pool_size = pool_size

      @mutex = Mutex.new
      @available = ConditionVariable.new
      @idle = []
      @owned = {}.compare_by_identity
      @pid = Process.pid
    end

    # Wraps a legacy Net::HTTP object (as passed to the sub-clients in earlier versions) in an HttpClient.
    def self.wrap(client)
      return client if client.is_a?(HttpClient)
      unless client.is_a?(Net::HTTP)
        raise ArgumentError, 'Copyleaks::HttpClient - client - must be a Copyleaks::HttpClient or a Net::HTTP'
      end

      scheme = client.use_ssl? ? 'https' : 'http'
      new(URI::Generic.build(scheme: scheme, host: client.address, port: client.port))
    end

    # Sends one request on a pooled connection and returns the Net::HTTPResponse.
    # When a block is given, it receives the response before the body is read, so the body
    # can be streamed with response.read_body { |chunk| ... }.
    def request(req, &block)
      conn = checkout
      reusable = false
      begin
        conn.start unless conn.started?
        response = conn.request(req, &block)
        reusable = true
        response
      ensure
        checkin(conn, reusable)
      end
    end

    # Number of connections currently open or checked out.
    def size
      @mutex.synchronize { @owned.size }
    end

    # Closes the idle connections. Connections in use are closed when they are returned.
    def close
      idle = @mutex.synchronize do
        list = @idle
        @idle = []
        list.each { |conn| @owned.delete(conn) }
        list
      end
      idle.each { |conn| finish_quietly(conn) }
      nil
    end

    private

    def checkout
      @mutex.synchronize do
        reset_after_fork
        loop do
          return @idle.pop unless @idle.empty?

          if @owned.size < @pool_size
            conn = build_connection
            @owned[conn] = true
            return conn
          end
          @available.wait(@mutex)
        end
      end
    end

    def checkin(conn, reusable)
      finish_quietly(conn) unless reusable
      @mutex.synchronize do
        # A connection checked out before a fork belongs to the parent process. Drop it.
        if @owned.key?(conn)
          if reusable
            @idle.push(conn)
          else
            @owned.delete(conn)
          end
        end
        @available.signal
      end
    end

    def reset_after_fork
      return if @pid == Process.pid

      # Do not close the inherited sockets: they are still used by the parent process.
      @idle = []
      @owned = {}.compare_by_identity
      @pid = Process.pid
    end

    def build_connection
      conn = Net::HTTP.new(@address, @port)
      conn.use_ssl = @use_ssl
      conn.verify_mode = OpenSSL::SSL::VERIFY_PEER if @use_ssl
      conn.open_timeout = @open_timeout
      conn.read_timeout = @read_timeout
      conn.write_timeout = @write_timeout if conn.respond_to?(:write_timeout=)
      conn.keep_alive_timeout = @keep_alive_timeout
      # Never resend a request on a timeout or a dropped connection. Net::HTTP retries idempotent
      # verbs (including PUT) once by default, which would upload a submit twice.
      conn.max_retries = 0
      conn
    end

    def finish_quietly(conn)
      conn.finish if conn.started?
    rescue StandardError
      nil
    end
  end
end
