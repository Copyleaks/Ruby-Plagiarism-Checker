module Copyleaks
  class UnderMaintenanceException < RuntimeError
    # The HTTP response (status 503), or nil when the exception was raised without one.
    attr_reader :response

    def initialize(response = nil)
      @response = response
      super 'Copyleaks is Under Maintenance, please visit https://status.copyleaks.com'
    end

    # The value of the Retry-After response header, or nil when the server did not send one.
    def retry_after
      @response.nil? ? nil : @response['Retry-After']
    end
  end
end
