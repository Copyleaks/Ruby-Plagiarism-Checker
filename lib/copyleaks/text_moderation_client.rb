module Copyleaks
  class TextModerationClient
    # @param [Copyleaks::HttpClient] api_client A Net::HTTP is also accepted.
    def initialize(api_client)
      @api_client = HttpClient.wrap(api_client)
    end

    # Scans text for unsafe or policy-violating content.
    # For more info: https://docs.copyleaks.com/reference/actions/text-moderation/check
    # @param [CopyleaksTextModerationRequestModel] submission
    def submit_text(authToken, scanId, submission)
      ClientUtils.send_authorized(@api_client, :post, '/v1/text-moderation/%s/check', 'submit_text_moderation',
                                  authToken, ids: { 'scanId' => scanId },
                                  model: [submission, CopyleaksTextModerationRequestModel,
                                          'submission is invalid, must be an instance of CopyleaksTextModerationRequestModel'])
    end
  end
end
