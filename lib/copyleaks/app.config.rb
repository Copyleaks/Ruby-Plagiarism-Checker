require_relative 'version.rb'

module Copyleaks
  # Process-wide defaults. Copyleaks::API.new also accepts identity_server_uri: and api_server_uri:
  # to override them for a single client.
  class Config
    @@identity_server_uri = 'https://id.copyleaks.com'
    @@api_server_uri = 'https://api.copyleaks.com'
    @@user_agent = "ruby-sdk/#{Copyleaks::VERSION}"

    def initialize(identity_server_uri, api_server_uri)
      @@identity_server_uri = identity_server_uri
      @@api_server_uri = api_server_uri
    end

    def self.identity_server_uri
      @@identity_server_uri
    end

    def self.api_server_uri
      @@api_server_uri
    end

    def self.identity_server_uri=(uri)
      @@identity_server_uri = uri
    end

    def self.api_server_uri=(uri)
      @@api_server_uri = uri
    end

    def self.user_agent
      @@user_agent
    end
  end
end
