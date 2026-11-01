require 'date'

module Copyleaks
  class CopyleaksAuthToken
    # A token this close to its expiry time is treated as expired, so it cannot expire mid-request.
    EXPIRY_MARGIN_SECONDS = 5 * 60

    attr_reader :expires, :accessToken, :issued

    def initialize(expires, accessToken, issued)
      unless expires.instance_of?(String)
        raise 'Copyleaks::CopyleaksAuthToken - expires - expires must be of type String'
      end
      unless accessToken.instance_of?(String)
        raise 'Copyleaks::CopyleaksAuthToken - accessToken - accessToken must be of type String'
      end
      raise 'Copyleaks::CopyleaksAuthToken - issued - issued must be of type String' unless issued.instance_of?(String)

      @expires = expires
      @accessToken = accessToken
      @issued = issued
    end

    # The expiry time as a Time. Parsed once and cached.
    def expires_at
      @expires_at ||= DateTime.parse(@expires).to_time
    end

    # True when the token has expired, or expires within margin_seconds.
    def expired?(margin_seconds = EXPIRY_MARGIN_SECONDS)
      expires_at - margin_seconds <= Time.now
    end

    def as_json(*_args)
      {
        expires: @expires,
        issued: @issued,
        accessToken: @accessToken
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
