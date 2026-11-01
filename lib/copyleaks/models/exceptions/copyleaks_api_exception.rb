module Copyleaks
  # An error response from the Copyleaks API. Rescue it to handle CommandException, RateLimitException and
  # UnderMaintenanceException together.
  class CopyleaksApiException < RuntimeError
    # The HTTP response, or nil when the exception was raised without one.
    attr_reader :response

    def initialize(message, response = nil)
      @response = response
      super(message)
    end

    # The value of the Retry-After response header, or nil when the server did not send one.
    def retry_after
      @response.nil? ? nil : @response['Retry-After']
    end
  end
end
