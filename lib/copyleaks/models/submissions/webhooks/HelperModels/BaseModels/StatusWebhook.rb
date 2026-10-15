module Copyleaks
  class StatusWebhook < Webhook
    attr_reader :status

    def initialize(status:, **args)
      unless status.is_a?(Integer)
        raise 'Copyleaks::StatusWebhook - status must be an Integer'
      end
      super(**args)
      @status = status
    end

    def as_json(*_args)
      {
        status: @status
      }.merge(super)
    end

    def to_json(*options)
      as_json.to_json(*options)
    end
  end
end
