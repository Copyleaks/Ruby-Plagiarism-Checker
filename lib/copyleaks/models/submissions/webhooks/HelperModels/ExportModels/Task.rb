module Copyleaks
  class Task
    attr_reader :endpoint, :isHealthy, :httpStatusCode

    # @param [Boolean] isHealthy False when the task hit an internal error on the Copyleaks side.
    # @param [Integer] httpStatusCode The status code your server returned; nil when isHealthy is false.
    def initialize(endpoint:, isHealthy:, httpStatusCode:)
      raise 'Copyleaks::Task - endpoint must be a String' unless endpoint.is_a?(String)
      raise 'Copyleaks::Task - isHealthy must be a Boolean' unless [true, false].include?(isHealthy)
      raise 'Copyleaks::Task - httpStatusCode must be an Integer' unless httpStatusCode.is_a?(Integer)

      @endpoint = endpoint
      @isHealthy = isHealthy
      @httpStatusCode = httpStatusCode
    end

    def as_json(*_args)
      {
        endpoint: @endpoint,
        isHealthy: @isHealthy,
        httpStatusCode: @httpStatusCode
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end