module Copyleaks
  # Async AI image detection request: Copyleaks downloads the image from url and posts the result to webhooks.url.
  class CopyleaksAiImageDetectionAsyncRequestModel
    attr_reader :url, :file_name, :model, :webhooks, :mask_type, :object_detection, :headers, :sandbox,
                :developer_payload

    # @param url [String] Publicly accessible image URL.
    # @param file_name [String] With extension: .jpg, .jpeg, .png, .webp, .tiff, .bmp, .heic, .heif.
    # @param model [String] See CopyleaksAiImageDetectionModels.
    # @param webhooks [CopyleaksAsyncWebhooksModel, String] A String is used as webhooks.url.
    # @param mask_type [String, nil] CopyleaksAiImageMaskTypes::BINARY (server default) or HEATMAP.
    # @param object_detection [Array<String>, nil] Up to 3 objects to locate, for example ['face'].
    # @param headers [Array<Array<String>>, nil] Sent with the image download, e.g. [['X-Custom-Auth', 'my-token']].
    # @param sandbox [Boolean, nil] Free mock results. Server default: false.
    # @param developer_payload [String, nil] Echoed back in the webhook.
    def initialize(url:, file_name:, model:, webhooks:, mask_type: nil, object_detection: nil, headers: nil,
                   sandbox: nil, developer_payload: nil)
      raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - url must be a String' unless url.is_a?(String)
      raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - file_name must be a String' unless file_name.is_a?(String)
      raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - model must be a String' unless model.is_a?(String)
      if !mask_type.nil? && !mask_type.is_a?(String)
        raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - mask_type must be a String'
      end
      unless Utils.headers_valid?(headers)
        raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - headers must be an Array of [name, value] String pairs'
      end
      if !sandbox.nil? && ![true, false].include?(sandbox)
        raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - sandbox must be a Boolean'
      end
      if !developer_payload.nil? && !developer_payload.is_a?(String)
        raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - developer_payload must be a String'
      end

      @url = url
      @file_name = file_name
      @model = model
      @webhooks = CopyleaksAsyncWebhooksModel.coerce(webhooks)
      @mask_type = mask_type
      @object_detection = CopyleaksAiImageDetectionRequestModel.normalize_object_detection(object_detection)
      @headers = headers
      @sandbox = sandbox
      @developer_payload = developer_payload
    end

    def as_json(*_args)
      {
        url: @url,
        fileName: @file_name,
        model: @model,
        maskType: @mask_type,
        objectDetection: @object_detection,
        headers: @headers,
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
