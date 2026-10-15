module Copyleaks
  class AIDetectionClient
    # @param [Copyleaks::HttpClient] api_client A Net::HTTP is also accepted.
    def initialize(api_client)
      @api_client = HttpClient.wrap(api_client)
    end

    # Detects whether a text was written by a human or by AI.
    # For more info: https://docs.copyleaks.com/reference/actions/writer-detector/check
    # @param [NaturalLanguageSubmissionModel] submission
    # @return [Hash] For typed access use CopyleaksAiTextDetectionResponseModel.from_json(result).
    def submit_natural_language(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(Copyleaks::NaturalLanguageSubmissionModel)
        raise 'submission is Invalid, must be instance of type Copyleaks::NaturalLanguageSubmissionModel'
      end

      ClientUtils.verify_auth_token(authToken)

      path = "/v2/writer-detector/#{ClientUtils.escape_path(scanId)}/check"
      ClientUtils.send_request(@api_client, :post, path, 'submit_natural_language', auth_token: authToken, json: submission)
    end

    # Returns the credit balance available for AI Text Detection.
    # For more info: https://docs.copyleaks.com/reference/actions/writer-detector/credits
    # @return [Hash] For example { 'credits' => 382 }.
    def get_credits_balance(authToken)
      ClientUtils.verify_auth_token(authToken)

      ClientUtils.send_request(@api_client, :get, '/v2/writer-detector/credits', 'get_ai_text_credits_balance',
                               auth_token: authToken)
    end
  end
end
