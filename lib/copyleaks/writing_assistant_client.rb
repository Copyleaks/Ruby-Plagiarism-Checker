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
  class WritingAssistantClient
    # @param [Copyleaks::HttpClient] api_client The pooled API connection (a Net::HTTP is also accepted).
    def initialize(api_client)
      @api_client = HttpClient.wrap(api_client)
    end

    # Get a list of correction types supported within the Writing Assistant API. Correction types apply to all supported languages. The supplied language code for this request is used to determine the language of the texts returned.
    # For more info: https://docs.copyleaks.com/reference/actions/writing-assistant/correction-types
    # @param [String] language_code The language for the returned texts to be in. Language codes are in ISO 639-1 standard. Supported Values: en - English
    def get_correction_types(language_code)
      path = "/v1/writing-feedback/correction-types/#{ClientUtils.escape_path(language_code)}"
      ClientUtils.send_request(@api_client, :get, path, 'get_correction_types')
    end

    # Use Copyleaks Writing Assistant to generate grammar, spelling and sentence corrections for a given text.
    # For more info: https://docs.copyleaks.com/reference/actions/writing-assistant/check
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Attach your own scan Id
    # @param [WritingAssistantSubmissionModel] submission document
    def submit_text(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      raise 'submission is invalid, must be an instance of WritingAssistantSubmissionModel' if submission.nil? || !submission.instance_of?(Copyleaks::WritingAssistantSubmissionModel)

      ClientUtils.verify_auth_token(authToken)

      path = "/v1/writing-feedback/#{ClientUtils.escape_path(scanId)}/check"
      ClientUtils.send_request(@api_client, :post, path, 'submit_writing_assistant', auth_token: authToken, json: submission)
    end
  end
end
