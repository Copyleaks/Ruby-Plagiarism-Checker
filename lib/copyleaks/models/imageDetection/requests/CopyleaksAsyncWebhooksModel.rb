module Copyleaks
  # Webhook settings for the asynchronous detectors (AI image async submit and AI video).
  class CopyleaksAsyncWebhooksModel
    attr_reader :url, :headers

    # @param url [String] Where Copyleaks posts the detection result.
    # @param headers [Array<Array<String>>, nil] Added to the webhook, e.g. [['Authorization', 'Bearer my-token']].
    def initialize(url, headers = nil)
      raise ArgumentError, 'Copyleaks::CopyleaksAsyncWebhooksModel - url must be a String' unless url.is_a?(String)
      unless Utils.headers_valid?(headers)
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
