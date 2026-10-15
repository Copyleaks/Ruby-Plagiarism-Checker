module Copyleaks
  class Webhook

    # Echoed from the submission.
    attr_reader :developerPayload

    def initialize(developerPayload: nil,**args)
      if !developerPayload.nil? && !developerPayload.is_a?(String)
        raise 'Copyleaks::Webhook - developerPayload must be a String'
      end
      @developerPayload = developerPayload
      @extra_fields = args
    end

    def as_json(*_args)
      {
        developerPayload: @developerPayload
      }.compact
    end

    def to_json(*options)
      as_json.to_json(*options)
    end
  end
end
