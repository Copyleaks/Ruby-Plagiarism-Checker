#
#  The MIT License(MIT)
#
#  Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
# =
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
