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
    def initialize(api_client)
      @api_client = api_client
    end

    # Use Copyleaks AI Content Detection to differentiate between human texts and AI written texts.
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Attach your own scan Id
    # @param [NaturalLanguageSubmissionModel] submission document
    def submit_natural_language(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(Copyleaks::NaturalLanguageSubmissionModel)
        raise 'submission is Invalid, must be instance of type Copyleaks::NaturalLanguageSubmissionModel'
      end

      ClientUtils.verify_auth_token(authToken)

      path = "/v2/writer-detector/#{scanId}/check"

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent,
        'Authorization' => "Bearer #{authToken.accessToken}"
      }

      request = Net::HTTP::Post.new(path, headers)
      request.body = submission.to_json

      res = ClientUtils.handle_response(@api_client.request(request), 'submit_natural_language')
      puts "RES: #{res}"
      res
    end
  end
end
