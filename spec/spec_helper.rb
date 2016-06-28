require 'webmock/rspec'
require 'copyleaks_api'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.order = :random
  Kernel.srand config.seed
  config.before(:each) { CopyleaksApi::Config.reset }
end

def fixture_path
  @fixture_path ||= File.join(File.dirname(__FILE__), 'fixtures')
end

def stub_api_request(method, path, status, body)
  stub_request(method, "https://api.copyleaks.com/v1/#{path}")
    .with(headers: { 'User-Agent' => "RUBYSDK/#{CopyleaksApi::VERSION}"}).
    to_return(status: status, body: body)
end

def delete_json
  @delete_json ||= File.read(File.join(fixture_path, 'responses', 'delete.json'))
end

def login_json
  @login_json ||= File.read(File.join(fixture_path, 'responses', 'login.json'))
end

def amount_json
  @amount_json ||= File.read(File.join(fixture_path, 'responses', 'balance.json'))
end

def created_json
  @ocr_json ||= File.read(File.join(fixture_path, 'responses', 'create_by.json'))
end

def list_json
  @list_json ||= File.read(File.join(fixture_path, 'responses', 'list.json'))
end

def result_json
  @result_json ||= File.read(File.join(fixture_path, 'responses', 'result.json'))
end

def status_json
  @status_json ||= File.read(File.join(fixture_path, 'responses', 'status.json'))
end

def stub_login
  stub_api_request(:post, 'account/login-api', 200, login_json)
end

