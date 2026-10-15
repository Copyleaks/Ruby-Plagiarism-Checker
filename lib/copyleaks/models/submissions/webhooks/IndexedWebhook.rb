module Copyleaks
  class IndexedWebhook < StatusWebhook
    def initialize(status:, developerPayload: nil, **args)
      super(status: status, developerPayload: developerPayload, **args)
    end

    
  end
end