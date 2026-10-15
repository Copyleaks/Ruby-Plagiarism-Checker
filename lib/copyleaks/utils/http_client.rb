require 'net/http'
require 'openssl'
require 'uri'

module Copyleaks
  # A small, thread-safe pool of keep-alive connections to one host.
  # * Each request checks out its own Net::HTTP connection, so two threads never share a socket.
  # * Requests are never retried automatically, so a submit that timed out is not uploaded twice.
  # * A connection that failed mid-request is dropped, never reused.
  # * After a fork, the child opens its own connections instead of sharing the parent's sockets.
  class HttpClient
    DEFAULT_OPEN_TIMEOUT = 10
    DEFAULT_READ_TIMEOUT = 120
    DEFAULT_WRITE_TIMEOUT = 120
    DEFAULT_KEEP_ALIVE_TIMEOUT = 30
    DEFAULT_POOL_SIZE = 5

    attr_reader :address, :port, :use_ssl, :open_timeout, :read_timeout, :write_timeout,
                :keep_alive_timeout, :pool_size

    # Timeouts are in seconds, as in API#initialize.
    # @param [String, URI] uri For example 'https://api.copyleaks.com'.
    # @param [Integer] pool_size Maximum open connections. Extra threads wait for a free one.
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

    # Wraps a Net::HTTP, as passed to the sub-clients by earlier versions.
    def self.wrap(client)
      return client if client.is_a?(HttpClient)
      unless client.is_a?(Net::HTTP)
        raise ArgumentError, 'Copyleaks::HttpClient - client - must be a Copyleaks::HttpClient or a Net::HTTP'
      end

      scheme = client.use_ssl? ? 'https' : 'http'
      new(URI::Generic.build(scheme: scheme, host: client.address, port: client.port))
    end

    # Sends one request on a pooled connection and returns the Net::HTTPResponse.
    # A block receives the response before the body is read, to stream it with read_body.
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
