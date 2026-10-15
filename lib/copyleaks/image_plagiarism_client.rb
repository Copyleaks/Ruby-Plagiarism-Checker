module Copyleaks
  class ImagePlagiarismClient
    # @param [Copyleaks::HttpClient] api_client A Net::HTTP is also accepted.
    def initialize(api_client)
      @api_client = HttpClient.wrap(api_client)
    end

    # Searches the web for copies of an image and returns the matches (synchronous, multipart upload).
    # For more info: https://docs.copyleaks.com/reference/actions/image-plagiarism-detector/check
    # @param [CopyleaksImagePlagiarismRequestModel] submission
    # @return [Hash] For typed access use CopyleaksImagePlagiarismResponseModel.from_json(result).
    def check(authToken, scanId, submission)
      ClientUtils.send_authorized(@api_client, :post, '/v1/image-plagiarism-detector/%s/check', 'check_image_plagiarism',
                                  authToken, ids: { 'scanId' => scanId },
                                  model: [submission, CopyleaksImagePlagiarismRequestModel,
                                          'submission is Invalid, must be instance of type Copyleaks::CopyleaksImagePlagiarismRequestModel'])
    end
  end
end
