module Copyleaks
  # HTTP 503 Service Unavailable.
  class UnderMaintenanceException < CopyleaksApiException
    def initialize(response = nil)
      super('Copyleaks is Under Maintenance, please visit https://status.copyleaks.com', response)
    end
  end
end
