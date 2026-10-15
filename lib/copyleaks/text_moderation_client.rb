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
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      raise 'submission is invalid, must be an instance of CopyleaksTextModerationRequestModel' if submission.nil? || !submission.instance_of?(Copyleaks::CopyleaksTextModerationRequestModel)

      ClientUtils.verify_auth_token(authToken)

      path = "/v1/text-moderation/#{ClientUtils.escape_path(scanId)}/check"
      ClientUtils.send_request(@api_client, :post, path, 'submit_text_moderation', auth_token: authToken, json: submission)
    end
  end
end
