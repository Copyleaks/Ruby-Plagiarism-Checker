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
  class AIVideoDetectionClient
    # @param [Copyleaks::HttpClient] api_client The pooled API connection (a Net::HTTP is also accepted).
    def initialize(api_client)
      @api_client = HttpClient.wrap(api_client)
    end

    # Submit a video URL for AI detection. Asynchronous: the server answers 201 Created right away
    # and posts the result to the webhook URL in the request when processing completes
    # (see Copyleaks::CopyleaksAiVideoDetectionResponseModel).
    # For more info: https://docs.copyleaks.com/reference/actions/ai-video-detector/submit
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Attach your own scan Id
    # @param [CopyleaksAiVideoDetectionRequestModel] submission The video URL, the webhook and the options.
    # @return [Hash, nil] The response body, usually empty.
    def submit(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(Copyleaks::CopyleaksAiVideoDetectionRequestModel)
        raise 'submission is Invalid, must be instance of type Copyleaks::CopyleaksAiVideoDetectionRequestModel'
      end

      ClientUtils.verify_auth_token(authToken)

      path = "/v1/ai-video-detector/#{ClientUtils.escape_path(scanId)}/submit"
      ClientUtils.send_request(@api_client, :post, path, 'submit_video_detection', auth_token: authToken,
                               json: submission)
    end
  end
end
