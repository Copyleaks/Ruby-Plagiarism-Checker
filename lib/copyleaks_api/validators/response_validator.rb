require 'json'

module CopyleaksApi
  module Validators
    class ResponseValidator
      ERROR_HEADER = 'Copyleaks-Error-Code'.freeze
      GOOD_STATUS_CODE = 200

      class << self
        # raises error if response has APi error code or bad status code
        def validate!(response)
          raise ManagedError.new(response[ERROR_HEADER]), extract_message(response.body) if response[ERROR_HEADER]
          raise BadResponseError.new(response.code), response.body if response.code.to_i != GOOD_STATUS_CODE
        end

        private

        # extract message from body
        def extract_message(string)
          JSON.parse(string)['Message']
        rescue JSON::ParserError
          string
        end
      end
    end
  end
end
