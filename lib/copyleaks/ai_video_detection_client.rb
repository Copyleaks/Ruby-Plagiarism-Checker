module Copyleaks
  class AIVideoDetectionClient
    # @param [Copyleaks::HttpClient] api_client A Net::HTTP is also accepted.
    def initialize(api_client)
      @api_client = HttpClient.wrap(api_client)
    end

    # Submits a video URL for AI detection (asynchronous). The server answers 201 Created and later
    # posts the result, shaped like CopyleaksAiVideoDetectionResponseModel, to the request's webhook.
    # For more info: https://docs.copyleaks.com/reference/actions/ai-video-detector/submit
    # @param [CopyleaksAiVideoDetectionRequestModel] submission
    # @return [Hash, nil] Usually empty.
    def submit(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(Copyleaks::CopyleaksAiVideoDetectionRequestModel)
        raise 'submission is Invalid, must be instance of type Copyleaks::CopyleaksAiVideoDetectionRequestModel'
      end

      ClientUtils.verify_auth_token(authToken)

      path = "/v1/ai-video-detector/#{ClientUtils.escape_path(scanId)}/submit"
      ClientUtils.send_request(@api_client, :post, path, 'submit_video_detection', auth_token: authToken,
                               json: submission)
    end
  end
end
