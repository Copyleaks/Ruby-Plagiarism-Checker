module Copyleaks
  # Async AI video detection request: Copyleaks downloads the video from url and posts the result to webhooks.url.
  class CopyleaksAiVideoDetectionRequestModel
    VERBS = %w[GET POST PUT].freeze

    attr_reader :url, :filename, :model, :webhooks, :headers, :verb, :sandbox, :developer_payload

    # @param url [String] Publicly accessible video URL.
    # @param filename [String] With extension, at most 255 characters.
    #   Supported: .mp4, .avi, .mov, .mkv, .webm, .flv, .wmv, .mpg, .m4v, .3gp, .mxf
    # @param model [String] See CopyleaksAiVideoDetectionModels.
    # @param webhooks [CopyleaksAsyncWebhooksModel, String] A String is used as webhooks.url.
    # @param headers [Array<Array<String>>, nil] Sent with the video download, e.g. [['X-Custom-Auth', 'my-token']].
    # @param verb [String, nil] HTTP method used to download the video: 'GET', 'POST' or 'PUT'.
    # @param sandbox [Boolean, nil] Free mock results. Server default: false.
    # @param developer_payload [String, nil] Echoed back in the webhook.
    def initialize(url:, filename:, model:, webhooks:, headers: nil, verb: nil, sandbox: nil, developer_payload: nil)
      raise ArgumentError, 'Copyleaks::CopyleaksAiVideoDetectionRequestModel - url must be a String' unless url.is_a?(String)
      raise ArgumentError, 'Copyleaks::CopyleaksAiVideoDetectionRequestModel - filename must be a String' unless filename.is_a?(String)
      raise ArgumentError, 'Copyleaks::CopyleaksAiVideoDetectionRequestModel - model must be a String' unless model.is_a?(String)
      unless CopyleaksAsyncWebhooksModel.headers_valid?(headers)
        raise ArgumentError, 'Copyleaks::CopyleaksAiVideoDetectionRequestModel - headers must be an Array of [name, value] String pairs'
      end
      if !verb.nil? && !VERBS.include?(verb)
        raise ArgumentError, "Copyleaks::CopyleaksAiVideoDetectionRequestModel - verb must be one of #{VERBS.join(', ')}"
      end
      if !sandbox.nil? && ![true, false].include?(sandbox)
        raise ArgumentError, 'Copyleaks::CopyleaksAiVideoDetectionRequestModel - sandbox must be a Boolean'
      end
      if !developer_payload.nil? && !developer_payload.is_a?(String)
        raise ArgumentError, 'Copyleaks::CopyleaksAiVideoDetectionRequestModel - developer_payload must be a String'
      end

      @url = url
      @filename = filename
      @model = model
      @webhooks = CopyleaksAsyncWebhooksModel.coerce(webhooks)
      @headers = headers
      @verb = verb
      @sandbox = sandbox
      @developer_payload = developer_payload
    end

    def as_json(*_args)
      {
        url: @url,
        headers: @headers,
        verb: @verb,
        filename: @filename,
        model: @model,
        webhooks: @webhooks.as_json,
        sandbox: @sandbox,
        developerPayload: @developer_payload
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
