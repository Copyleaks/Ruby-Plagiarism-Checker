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
      ClientUtils.send_authorized(@api_client, :post, '/v1/ai-video-detector/%s/submit', 'submit_video_detection',
                                  authToken, ids: { 'scanId' => scanId },
                                  model: [submission, CopyleaksAiVideoDetectionRequestModel,
                                          'submission is Invalid, must be instance of type Copyleaks::CopyleaksAiVideoDetectionRequestModel'])
    end
  end
end
