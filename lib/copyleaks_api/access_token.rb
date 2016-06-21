require 'time'
require 'json'

module CopyleaksApi
  class AccessToken
    attr_reader :created_at, :expire_at

    # constructor
    def initialize(cloud, email, api_key)
      @cloud = cloud
      @email = email
      @api_key = api_key
      login
    end

    # predicate method to check if token is not expired
    def fresh?
      DateTime.now.new_offset(0) < @expire_at
    end

    # return token string
    def token
      return @token if fresh?
      login
    end

    # get token for given email and api_key pair
    def login
      res = @cloud.api.post('account/login-api', { Email: @email, ApiKey: @api_key }.to_json)
      @token = res['access_token']
      @created_at = DateTime.parse(res['.issued'])
      @expire_at = DateTime.parse(res['.expires'])
      @token
    end
  end
end
