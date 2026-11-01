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
      ClientUtils.send_authorized(@api_client, :post, '/v2/writer-detector/%s/check', 'submit_natural_language',
                                  authToken, ids: { 'scanId' => scanId },
                                  model: [submission, NaturalLanguageSubmissionModel,
                                          'submission is Invalid, must be instance of type Copyleaks::NaturalLanguageSubmissionModel'])
    end

    # Returns the credit balance available for AI Text Detection.
    # For more info: https://docs.copyleaks.com/reference/actions/writer-detector/credits
    # @return [Hash] For example { 'credits' => 382 }.
    def get_credits_balance(authToken)
      ClientUtils.send_authorized(@api_client, :get, '/v2/writer-detector/credits', 'get_ai_text_credits_balance',
                                  authToken)
    end
  end
end
