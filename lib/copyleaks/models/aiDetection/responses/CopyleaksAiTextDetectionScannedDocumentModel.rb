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
  # Metadata about an AI Text Detection scan.
  class CopyleaksAiTextDetectionScannedDocumentModel
    attr_accessor :scan_id, :total_words, :total_excluded, :actual_credits, :expected_credits, :creation_time

    def initialize(scan_id: nil, total_words: nil, total_excluded: nil, actual_credits: nil, expected_credits: nil,
                   creation_time: nil)
      @scan_id = scan_id
      @total_words = total_words
      @total_excluded = total_excluded
      @actual_credits = actual_credits
      @expected_credits = expected_credits
      @creation_time = creation_time
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        scan_id: json_hash['scanId'],
        total_words: json_hash['totalWords'],
        total_excluded: json_hash['totalExcluded'],
        # The API sends actualCredits; credits is accepted too.
        actual_credits: json_hash.key?('actualCredits') ? json_hash['actualCredits'] : json_hash['credits'],
        expected_credits: json_hash['expectedCredits'],
        creation_time: json_hash['creationTime']
      )
    end

    def to_json(*args)
      {
        'scanId' => @scan_id,
        'totalWords' => @total_words,
        'totalExcluded' => @total_excluded,
        'actualCredits' => @actual_credits,
        'expectedCredits' => @expected_credits,
        'creationTime' => @creation_time
      }.compact.to_json(*args)
    end
  end
end
