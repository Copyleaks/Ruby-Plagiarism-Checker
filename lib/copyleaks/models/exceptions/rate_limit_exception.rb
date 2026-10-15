module Copyleaks
  # HTTP 429 Too Many Requests.
  class RateLimitException < CopyleaksApiException
    def initialize(response = nil)
      super('Too many requests. Please wait before calling again.', response)
    end
  end
end
