# frozen_string_literal: true

# ********************************************************************************
# The MIT License(MIT)
#
# Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ********************************************************************************

module Copyleaks
  # A classified section of the text.
  class CopyleaksAiTextDetectionResultModel
    # The classification of the section.
    # 1 = human-written text, 2 = AI-generated text.
    attr_accessor :classification

    # The probability of the classification.
    # Deprecated by the server; it is planned to be removed.
    attr_accessor :probability

    # The positions of the text classified in this section.
    attr_accessor :matches

    # Initialize a new CopyleaksAiTextDetectionResultModel
    #
    # @param classification [Integer] The classification of the section (1 = human, 2 = AI)
    # @param probability [Float] The probability of the classification (deprecated by the server)
    # @param matches [Array<CopyleaksAiTextDetectionMatchModel>] The positions of the text classified in this section
    def initialize(classification: nil, probability: nil, matches: nil)
      @classification = classification
      @probability = probability
      @matches = matches
    end

    # Create instance from JSON hash
    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      matches = json_hash['matches'].map { |m| CopyleaksAiTextDetectionMatchModel.from_json(m) } if json_hash['matches'].is_a?(Array)

      new(
        classification: json_hash['classification'],
        probability: json_hash['probability'],
        matches: matches
      )
    end

    # Convert to JSON
    def to_json(*args)
      {
        'classification' => @classification,
        'probability' => @probability,
        'matches' => @matches
      }.compact.to_json(*args)
    end
  end
end
