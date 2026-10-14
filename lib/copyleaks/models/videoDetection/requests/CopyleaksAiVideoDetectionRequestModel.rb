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
  # Request model for the asynchronous AI video detection submit.
  # Copyleaks downloads the video from url and posts the result to webhooks.url.
  class CopyleaksAiVideoDetectionRequestModel
    VERBS = %w[GET POST PUT].freeze

    attr_reader :url, :filename, :model, :webhooks, :headers, :verb, :sandbox, :developer_payload

    # @param url [String] Publicly accessible URL of the video to analyze.
    # @param filename [String] The name of the video file including its extension (at most 255 characters).
    #   Supported: .mp4, .avi, .mov, .mkv, .webm, .flv, .wmv, .mpg, .m4v, .3gp, .mxf
    # @param model [String] The AI detection model, for example CopyleaksAiVideoDetectionModels::AI_VIDEO_1_PRO.
    # @param webhooks [CopyleaksAsyncWebhooksModel, String] Where to send the result. A String is used as webhooks.url.
    # @param headers [Array<Array<String>>, nil] Headers Copyleaks sends when it downloads the video,
    #   for example [['X-Custom-Auth', 'my-token']].
    # @param verb [String, nil] The HTTP method used to download the video: 'GET', 'POST' or 'PUT'.
    # @param sandbox [Boolean, nil] Use sandbox mode: free, returns mock results. Server default: false.
    # @param developer_payload [String, nil] A string that is echoed back in the webhook.
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
