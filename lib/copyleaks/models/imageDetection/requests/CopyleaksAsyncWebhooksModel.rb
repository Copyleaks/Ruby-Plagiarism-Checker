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


module Copyleaks
  # Webhook settings for the asynchronous detectors (AI image async submit and AI video).
  class CopyleaksAsyncWebhooksModel
    attr_reader :url, :headers

    # @param url [String] The URL Copyleaks posts the detection result to.
    # @param headers [Array<Array<String>>, nil] Headers added to the webhook request,
    #   for example [['Authorization', 'Bearer my-webhook-token']].
    def initialize(url, headers = nil)
      raise ArgumentError, 'Copyleaks::CopyleaksAsyncWebhooksModel - url must be a String' unless url.is_a?(String)
      unless self.class.headers_valid?(headers)
        raise ArgumentError, 'Copyleaks::CopyleaksAsyncWebhooksModel - headers must be an Array of [name, value] String pairs'
      end

      @url = url
      @headers = headers
    end

    # Accepts a CopyleaksAsyncWebhooksModel or a URL String.
    def self.coerce(value)
      return value if value.is_a?(CopyleaksAsyncWebhooksModel)
      return new(value) if value.is_a?(String)

      raise ArgumentError, 'webhooks must be a Copyleaks::CopyleaksAsyncWebhooksModel or a URL String'
    end

    def self.headers_valid?(headers)
      return true if headers.nil?
      return false unless headers.is_a?(Array)

      headers.all? { |pair| pair.is_a?(Array) && pair.length == 2 && pair.all? { |part| part.is_a?(String) } }
    end

    def as_json(*_args)
      {
        url: @url,
        headers: @headers
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
