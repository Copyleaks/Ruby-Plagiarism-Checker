# frozen_string_literal: true

require_relative 'test_helper'

class HttpClientTest < Minitest::Test
  include CopyleaksTestHelpers

  def file_submission
    Copyleaks::CopyleaksFileSubmissionModel.new(Base64.strict_encode64('hello'), 'a.txt', properties)
  end

  def test_sequential_requests_reuse_one_kept_alive_connection
    3.times { api.get_credits_balance(token) }

    ports = @server.requests.map(&:peer_port).uniq
    assert_equal 3, @server.requests.size
    assert_equal 1, ports.size, 'every call should reuse the same TCP connection'
    @server.requests.each { |r| refute_equal 'close', r.headers['connection'] }
  end

  def test_one_client_is_safe_to_share_between_threads
    @server.respond do |req|
      scan_id = req.path.split('/')[5]
      sleep 0.01 # widen the window for interleaving
      [201, { 'Content-Type' => 'application/json' }, { scanId: scan_id }.to_json]
    end
    client = api(pool_size: 3)
    auth = token
    errors = Queue.new
    threads = Array.new(8) do |t|
      Thread.new do
        10.times do |i|
          id = "scan-#{t}-#{i}"
          result = client.submit_file(auth, id, file_submission)
          errors << "#{id} got #{result.inspect}" unless result == { 'scanId' => id }
        end
      rescue StandardError => e
        errors << "#{e.class}: #{e.message}"
      end
    end
    threads.each(&:join)

    assert errors.empty?, "errors: #{Array.new(errors.size) { errors.pop }.first(5).inspect}"
    assert_equal 80, @server.requests.size
    assert_operator @server.requests.map(&:peer_port).uniq.size, :<=, 3, 'the pool must not open more than pool_size connections'
  end

  def test_timed_out_put_is_not_sent_again
    @server.respond do |req|
      sleep 1.5 if req.method == 'PUT'
      [201, { 'Content-Type' => 'application/json' }, '{}']
    end
    client = api(read_timeout: 0.5)

    assert_raises(Net::ReadTimeout) { client.submit_file(token, 'timeout-scan', file_submission) }
    sleep 2 # long enough for a retry to reach the server, if one were made
    puts_seen = @server.requests.count { |r| r.method == 'PUT' }
    assert_equal 1, puts_seen, 'a PUT submit must never be resent after a timeout'

    # The broken connection was dropped; the client keeps working on a new one.
    client.get_credits_balance(token)
    assert_equal 'GET', @server.last_request.method
  end

  def test_connections_disable_net_http_retries_and_use_the_configured_timeouts
    http = Copyleaks::HttpClient.new('https://api.copyleaks.com', open_timeout: 3, read_timeout: 7, write_timeout: 9,
                                                                  keep_alive_timeout: 11, pool_size: 2)
    conn = http.send(:checkout)
    assert_equal 0, conn.max_retries
    assert_equal 3, conn.open_timeout
    assert_equal 7, conn.read_timeout
    assert_equal 9, conn.write_timeout
    assert_equal 11, conn.keep_alive_timeout
    assert conn.use_ssl?
    assert_equal OpenSSL::SSL::VERIFY_PEER, conn.verify_mode
  end

  def test_api_passes_timeouts_to_both_servers
    client = Copyleaks::API.new(open_timeout: 4, read_timeout: 5, write_timeout: 6, keep_alive_timeout: 7, pool_size: 8)
    [client.instance_variable_get(:@api_client), client.instance_variable_get(:@id_client)].each do |http|
      assert_equal [4, 5, 6, 7, 8], [http.open_timeout, http.read_timeout, http.write_timeout, http.keep_alive_timeout, http.pool_size]
    end
    assert_equal 'api.copyleaks.com', client.instance_variable_get(:@api_client).address
    assert_equal 'id.copyleaks.com', client.instance_variable_get(:@id_client).address
  end

  def test_default_timeouts
    http = Copyleaks::API.new.instance_variable_get(:@api_client)
    assert_equal [10, 120, 120, 30, 5], [http.open_timeout, http.read_timeout, http.write_timeout, http.keep_alive_timeout, http.pool_size]
  end

  def test_invalid_options_are_rejected
    assert_raises(ArgumentError) { Copyleaks::API.new(read_timeout: 0) }
    assert_raises(ArgumentError) { Copyleaks::API.new(open_timeout: 'x') }
    assert_raises(ArgumentError) { Copyleaks::API.new(pool_size: 0) }
  end

  def test_failed_connection_is_dropped_from_the_pool
    @server.respond do |req|
      sleep 1 if req.path.include?('slow')
      [200, { 'Content-Type' => 'application/json' }, '{}']
    end
    client = api(read_timeout: 0.3)
    client.resend_webhook(token, 'fast')
    http = client.instance_variable_get(:@api_client)
    assert_equal 1, http.size

    assert_raises(Net::ReadTimeout) { client.resend_webhook(token, 'slow') }
    assert_equal 0, http.size, 'the timed-out connection must be closed, not returned to the pool'
  end

  def test_close_releases_idle_connections_and_client_stays_usable
    client = api
    client.get_credits_balance(token)
    http = client.instance_variable_get(:@api_client)
    assert_equal 1, http.size
    client.close
    assert_equal 0, http.size
    client.get_credits_balance(token)
    assert_equal 2, @server.requests.map(&:peer_port).uniq.size
  end

  def test_child_process_does_not_reuse_the_parents_connections
    client = api
    client.get_credits_balance(token)
    http = client.instance_variable_get(:@api_client)
    Process.stub(:pid, Process.pid + 1) do
      client.get_credits_balance(token)
    end
    ports = @server.requests.map(&:peer_port)
    refute_equal ports[0], ports[1], 'after a fork the pool must open a new connection'
    assert_equal 1, http.size
  end

  def test_sub_clients_still_accept_a_net_http_object
    legacy = Net::HTTP.new('127.0.0.1', @server.port)
    client = Copyleaks::WritingAssistantClient.new(legacy)
    client.get_correction_types('en')
    assert_equal '/v1/writing-feedback/correction-types/en', @server.last_request.path
  end
end
