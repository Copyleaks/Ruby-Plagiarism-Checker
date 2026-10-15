module Copyleaks
  class WritingAssistantClient
    # @param [Copyleaks::HttpClient] api_client A Net::HTTP is also accepted.
    def initialize(api_client)
      @api_client = HttpClient.wrap(api_client)
    end

    # Lists the Writing Assistant correction types. They apply to all supported languages.
    # For more info: https://docs.copyleaks.com/reference/actions/writing-assistant/correction-types
    # @param [String] language_code ISO 639-1 language of the returned texts. Supported: 'en'.
    def get_correction_types(language_code)
      path = "/v1/writing-feedback/correction-types/#{ClientUtils.escape_path(language_code)}"
      ClientUtils.send_request(@api_client, :get, path, 'get_correction_types')
    end

    # Returns grammar, spelling and sentence corrections for a text.
    # For more info: https://docs.copyleaks.com/reference/actions/writing-assistant/check
    # @param [WritingAssistantSubmissionModel] submission
    def submit_text(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      raise 'submission is invalid, must be an instance of WritingAssistantSubmissionModel' if submission.nil? || !submission.instance_of?(Copyleaks::WritingAssistantSubmissionModel)

      ClientUtils.verify_auth_token(authToken)

      path = "/v1/writing-feedback/#{ClientUtils.escape_path(scanId)}/check"
      ClientUtils.send_request(@api_client, :post, path, 'submit_writing_assistant', auth_token: authToken, json: submission)
    end
  end
end
