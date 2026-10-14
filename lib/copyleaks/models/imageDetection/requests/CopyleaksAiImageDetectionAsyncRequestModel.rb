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
  # Request model for the asynchronous AI image detection submit.
  # Copyleaks downloads the image from url and posts the result to webhooks.url.
  class CopyleaksAiImageDetectionAsyncRequestModel
    attr_reader :url, :file_name, :model, :webhooks, :mask_type, :object_detection, :headers, :sandbox,
                :developer_payload

    # @param url [String] Publicly accessible URL of the image to analyze.
    # @param file_name [String] The name of the image file including its extension.
    #   Supported: .jpg, .jpeg, .png, .webp, .tiff, .bmp, .heic, .heif
    # @param model [String] The AI detection model, for example CopyleaksAiImageDetectionModels::AI_IMAGE_1_ULTRA.
    # @param webhooks [CopyleaksAsyncWebhooksModel, String] Where to send the result. A String is used as webhooks.url.
    # @param mask_type [String, nil] CopyleaksAiImageMaskTypes::BINARY (server default) or HEATMAP.
    # @param object_detection [Array<String>, nil] Up to 3 objects to locate, for example ['face'].
    # @param headers [Array<Array<String>>, nil] Headers Copyleaks sends when it downloads the image,
    #   for example [['X-Custom-Auth', 'my-token']].
    # @param sandbox [Boolean, nil] Use sandbox mode: free, returns mock results. Server default: false.
    # @param developer_payload [String, nil] A string that is echoed back in the webhook.
    def initialize(url:, file_name:, model:, webhooks:, mask_type: nil, object_detection: nil, headers: nil,
                   sandbox: nil, developer_payload: nil)
      raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - url must be a String' unless url.is_a?(String)
      raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - file_name must be a String' unless file_name.is_a?(String)
      raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - model must be a String' unless model.is_a?(String)
      if !mask_type.nil? && !mask_type.is_a?(String)
        raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel - mask_type must be a String'
      end
      unless CopyleaksAsyncWebhooksModel.headers_valid?(headers)
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
