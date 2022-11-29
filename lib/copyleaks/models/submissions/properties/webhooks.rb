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
  class SubmissionWebhooks
    # @param [String] status This webhook event is triggered once the scan status changes. Use the special token {STATUS} to track the current scan status. This special token will automatically be replaced by the Copyleaks servers with the optional values: completed, error, creditsChecked and indexed. Read more about webhooks: https://api.copyleaks.com/documentation/v3/webhooks
    # @param [String] newResult Http endpoint to be triggered while the scan is still running and a new result is found. This is useful when the report is being viewed by the user in real time so the results will load gradually as they are found.
    # @param [Array] statusHeaders Adds headers to the webhook.
    # @param [Array] newResultHeaders Adds headers to the webhook.
    def initialize(status, newResult = nil, statusHeaders = nil, newResultHeaders = nil)
      unless status.instance_of? String
        raise 'Copyleaks::SubmissionWebhooks - status - status must be of type String'
      end
      unless newResult.nil? || newResult.instance_of?(String)
        raise 'Copyleaks::SubmissionWebhooks - newResult - newResult must be of type String'
      end
      unless header_format_valid?(statusHeaders)
        raise 'Copyleaks::SubmissionWebhooks - statusHeaders - statusHeaders must be an Array of String Array pairs'
      end
      unless header_format_valid?(newResultHeaders)
        raise 'Copyleaks::SubmissionWebhooks - newResultHeaders - newResultHeaders must be an Array of String Array pairs'
      end

      @newResult = newResult
      @status = status
      @statusHeaders = statusHeaders
      @newResultHeaders = newResultHeaders
    end

    def as_json(*_args)
      {
        newResult: @newResult,
        status: @status,
        statusHeaders: @statusHeaders,
        newResultHeaders: @newResultHeaders
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    private

    def header_format_valid?(header)
      return true if header.nil?
      return false unless header.instance_of?(Array)

      header.all? do |pair|
        pair.instance_of?(Array) && pair.length == 2 && pair[0].instance_of?(String) && pair[1].instance_of?(String)
      end
    end
  end
end
