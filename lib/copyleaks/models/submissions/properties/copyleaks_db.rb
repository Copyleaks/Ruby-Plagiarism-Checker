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
  class SubmissionScanningCopyleaksDB
    # @param [Boolean] includeMySubmissions When set to true: Copyleaks will also compare against content which was uploaded by YOU to the Copyleaks internal database. If true, it will also index the scan in the Copyleaks internal database.
    # @param [Boolean] includeOthersSubmissions  When set to true: Copyleaks will also compare against content which was uploaded by OTHERS to the Copyleaks internal database. If true, it will also index the scan in the Copyleaks internal database.
    def initialize(includeMySubmissions, includeOthersSubmissions)
      @includeMySubmissions = includeMySubmissions
      @includeOthersSubmissions = includeOthersSubmissions
    end

    def as_json(*_args)
      {
        includeMySubmissions: @includeMySubmissions,
        includeOthersSubmissions: @includeOthersSubmissions
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end