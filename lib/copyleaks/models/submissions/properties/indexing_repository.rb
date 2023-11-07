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

require_relative  './repository.rb'

module Copyleaks
    class SubmissionIndexingRepository < SubmissionRepository
      # @param [String] ID of a repository to add the scanned document to.
      # @param [SubmissionMaskingPolicy] maskingPolicy specify the document maskig ploicy.
      def initialize(id, maskingPolicy = nil)
        super(id)
        if !maskingPolicy.nil? && ![0, 1, 2].include?(maskingPolicy)
            raise 'Copyleaks::SubmissionIndexingRepository - maskingPolicy - maskingPolicy must be of type SubmissionMaskingPolicy'
        end
        @maskingPolicy = maskingPolicy
      end
  
      def as_json(*_args)
        {
            id: @id,
            maskingPolicy: @maskingPolicy,
        }.select { |_k, v| !v.nil? }
      end
  
      def to_json(*options)
        as_json(*options).to_json(*options)
      end
    end
  end
