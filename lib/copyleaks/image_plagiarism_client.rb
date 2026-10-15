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
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(Copyleaks::CopyleaksImagePlagiarismRequestModel)
        raise 'submission is Invalid, must be instance of type Copyleaks::CopyleaksImagePlagiarismRequestModel'
      end

      ClientUtils.verify_auth_token(authToken)

      path = "/v1/image-plagiarism-detector/#{ClientUtils.escape_path(scanId)}/check"
      ClientUtils.send_request(@api_client, :post, path, 'check_image_plagiarism', auth_token: authToken,
                               multipart: submission.to_multipart)
    end
  end
end
