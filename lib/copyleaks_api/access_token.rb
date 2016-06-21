require 'time'
require 'json'

module CopyleaksApi
  class AccessToken
    attr_reader :created_at, :expire_at

    def initialize(email, api_key)
      @email = email
      @api_key = api_key
      login
    end

    def fresh?
      DateTime.now.new_offset(0) < @expire_at
    end

    def token
      return @token if fresh?
      login
    end

    def login
      res = API.post('account/login-api', { Email: @email, ApiKey: @api_key }.to_json)
      @token = res['access_token']
      @created_at = DateTime.parse(res['.issued'])
      @expire_at = DateTime.parse(res['.expires'])
      @token
    end
  end
end
