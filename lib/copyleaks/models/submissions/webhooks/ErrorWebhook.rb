module Copyleaks
  class ErrorWebhook < StatusWebhook
    attr_reader :error

    def initialize(error: nil, **args)
      super(**args)
      @error = error
    end

    def as_json(*_args)
      super.merge(
        {
          error: @error.respond_to?(:as_json) ? @error.as_json : @error
        }
      )
    end

    def to_json(*options)
      as_json.to_json(*options)
    end
  end
end
