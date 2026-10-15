# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'minitest/autorun'
require 'minitest/mock'
require 'webrick'
require 'logger'
require 'json'
require 'base64'
require 'stringio'
require 'copyleaks'

# A local HTTP server that records every request and answers with a configurable response.
# It runs on 127.0.0.1 with a random port and supports keep-alive, so the tests exercise the
# real Net::HTTP connection pool without any network access.
class StubServer
  Request = Struct.new(:method, :path, :headers, :body, :peer_port)

  attr_reader :port

  def initialize
    @requests = []
    @lock = Mutex.new
    @handler = ->(_req) { [200, { 'Content-Type' => 'application/json' }, '{}'] }
    started = Queue.new
    @server = WEBrick::HTTPServer.new(
      BindAddress: '127.0.0.1',
      Port: 0,
      Logger: WEBrick::Log.new(File::NULL),
      AccessLog: [],
      DoNotReverseLookup: true,
      StartCallback: -> { started << true }
    )
    @port = @server.config[:Port]
    stub = self
    servlet = Class.new(WEBrick::HTTPServlet::AbstractServlet) do
      define_method(:service) { |req, res| stub.handle(req, res) }
    end
    @server.mount('/', servlet)
    @thread = Thread.new { @server.start }
    started.pop
  end

  def url
    "http://127.0.0.1:#{@port}"
  end

  # The block receives a StubServer::Request and returns [status, headers, body].
  def respond(&block)
    @handler = block
  end

  def requests
    @lock.synchronize { @requests.dup }
  end

  def last_request
    requests.last
  end

  def clear
    @lock.synchronize { @requests.clear }
  end

  def handle(req, res)
    headers = {}
    req.header.each { |name, values| headers[name.downcase] = values.join(', ') }
    record = Request.new(req.request_method, req.unparsed_uri, headers, req.body.to_s, req.peeraddr[1])
    @lock.synchronize { @requests << record }
    status, response_headers, body = @handler.call(record)
    res.status = status
    (response_headers || {}).each { |name, value| res[name] = value }
    res.body = body.to_s
  end

  def shutdown
    @server.shutdown
    @thread.join(5)
  end
end

module CopyleaksTestHelpers
  WEBHOOK = 'https://example.com/webhook/{STATUS}'

  def setup
    @server = StubServer.new
  end

  def teardown
    @api&.close
    @server.shutdown
  end

  def api(**options)
    @api ||= Copyleaks::API.new(api_server_uri: @server.url, identity_server_uri: @server.url, **options)
  end

  def token
    Copyleaks::CopyleaksAuthToken.new((Time.now.utc + 3600 * 24).iso8601, 'test-access-token', Time.now.utc.iso8601)
  end

  def properties(**options)
    Copyleaks::SubmissionProperties.new(Copyleaks::SubmissionWebhooks.new(WEBHOOK), nil, nil, true, **options)
  end

  def json_body(request)
    JSON.parse(request.body)
  end

  def json_of(model)
    JSON.parse(model.to_json)
  end

  def assert_json_headers(request, authorized: true)
    assert_equal 'application/json', request.headers['content-type']
    assert_equal "ruby-sdk/#{Copyleaks::VERSION}", request.headers['user-agent']
    if authorized
      assert_equal 'Bearer test-access-token', request.headers['authorization']
    else
      assert_nil request.headers['authorization']
    end
  end

  # Splits a multipart/form-data body into { name => { filename:, content_type:, value: } }.
  def multipart_parts(request)
    boundary = request.headers['content-type'][/boundary=(.+)\z/, 1]
    refute_nil boundary, 'multipart boundary missing'
    body = request.body.b
    assert body.end_with?("--#{boundary}--\r\n"), 'multipart body is not terminated'
    parts = body.split("--#{boundary}")[1..-2]
    parts.each_with_object({}) do |part, out|
      head, value = part.sub(/\A\r\n/, '').split("\r\n\r\n", 2)
      name = head[/name="([^"]*)"/, 1]
      out[name] = {
        filename: head[/filename="([^"]*)"/, 1],
        content_type: head[/Content-Type: (.+)/, 1]&.strip,
        value: value.sub(/\r\n\z/, '')
      }
    end
  end

  # A small valid PNG (binary String with bytes above 0x7F), built in memory.
  def png_bytes
    @png_bytes ||= begin
      require 'zlib'
      width = 4
      height = 4
      raw = (0...height).map { |y| "\x00".b + (0...width).map { |x| [x * 60, y * 60, 200].pack('C*') }.join }.join
      chunk = ->(type, data) { [data.bytesize].pack('N') + type + data + [Zlib.crc32(type + data)].pack('N') }
      "\x89PNG\r\n\x1a\n".b + chunk.call('IHDR'.b, [width, height, 8, 2, 0, 0, 0].pack('NNC5')) +
        chunk.call('IDAT'.b, Zlib::Deflate.deflate(raw)) + chunk.call('IEND'.b, ''.b)
    end
  end
end
