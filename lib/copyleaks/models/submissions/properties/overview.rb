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
  # Gen-AI Overview: extract key insights from the scan data.
  # Every field is optional. A field left nil is not sent, and the server default (false) applies.
  class SubmissionOverview
    attr_reader :enable, :ignoreAIDetection, :ignorePlagiarismDetection, :ignoreWritingFeedback, :ignoreAuthorData

    # @param [Boolean] enable Enable the Gen-AI Overview for this scan.
    # @param [Boolean] ignoreAIDetection Ignore AI detection when generating the overview.
    # @param [Boolean] ignorePlagiarismDetection Ignore plagiarism detection when generating the overview.
    # @param [Boolean] ignoreWritingFeedback Ignore the Grammar Checker when generating the overview.
    # @param [Boolean] ignoreAuthorData Ignore the author's historical data when generating the overview.
    def initialize(enable = nil, ignoreAIDetection: nil, ignorePlagiarismDetection: nil, ignoreWritingFeedback: nil,
                   ignoreAuthorData: nil)
      {
        enable: enable,
        ignoreAIDetection: ignoreAIDetection,
        ignorePlagiarismDetection: ignorePlagiarismDetection,
        ignoreWritingFeedback: ignoreWritingFeedback,
        ignoreAuthorData: ignoreAuthorData
      }.each do |name, value|
        if !value.nil? && ![true, false].include?(value)
          raise "Copyleaks::SubmissionOverview - #{name} - #{name} must be of type Boolean"
        end
      end

      @enable = enable
      @ignoreAIDetection = ignoreAIDetection
      @ignorePlagiarismDetection = ignorePlagiarismDetection
      @ignoreWritingFeedback = ignoreWritingFeedback
      @ignoreAuthorData = ignoreAuthorData
    end

    def as_json(*_args)
      {
        enable: @enable,
        ignoreAIDetection: @ignoreAIDetection,
        ignorePlagiarismDetection: @ignorePlagiarismDetection,
        ignoreWritingFeedback: @ignoreWritingFeedback,
        ignoreAuthorData: @ignoreAuthorData
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
