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
  class AIDetectionClient
    # @param [Copyleaks::HttpClient] api_client The pooled API connection (a Net::HTTP is also accepted).
    def initialize(api_client)
      @api_client = HttpClient.wrap(api_client)
    end

    # Use Copyleaks AI Content Detection to differentiate between human texts and AI written texts.
    # For more info: https://docs.copyleaks.com/reference/actions/writer-detector/check
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Attach your own scan Id
    # @param [NaturalLanguageSubmissionModel] submission document
    # @return [Hash] The AI detection result. Copyleaks::CopyleaksAiTextDetectionResponseModel.from_json(result)
    #   gives typed access.
    def submit_natural_language(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(Copyleaks::NaturalLanguageSubmissionModel)
        raise 'submission is Invalid, must be instance of type Copyleaks::NaturalLanguageSubmissionModel'
      end

      ClientUtils.verify_auth_token(authToken)

      path = "/v2/writer-detector/#{ClientUtils.escape_path(scanId)}/check"
      ClientUtils.send_request(@api_client, :post, path, 'submit_natural_language', auth_token: authToken, json: submission)
    end

    # Get the credit balance available for AI Text Detection.
    # For more info: https://docs.copyleaks.com/reference/actions/writer-detector/credits
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @return [Hash] For example { 'credits' => 382 }.
    def get_credits_balance(authToken)
      ClientUtils.verify_auth_token(authToken)

      ClientUtils.send_request(@api_client, :get, '/v2/writer-detector/credits', 'get_ai_text_credits_balance',
                               auth_token: authToken)
    end
  end
end
