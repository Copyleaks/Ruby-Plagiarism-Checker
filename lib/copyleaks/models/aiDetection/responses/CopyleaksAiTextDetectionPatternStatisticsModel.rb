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
  # Statistics of the AI patterns found in the text.
  # Each array has one entry per pattern, in the same order.
  class CopyleaksAiTextDetectionPatternStatisticsModel
    # How often each pattern appears in AI-generated text.
    attr_accessor :ai_count

    # How often each pattern appears in human-written text.
    attr_accessor :human_count

    # The ratio between the AI and human frequency of each pattern.
    attr_accessor :proportion

    # The source of each pattern. 1 = AI, 2 = humanizer.
    attr_accessor :source

    # Initialize a new CopyleaksAiTextDetectionPatternStatisticsModel
    #
    # @param ai_count [Array<Float>] How often each pattern appears in AI-generated text
    # @param human_count [Array<Float>] How often each pattern appears in human-written text
    # @param proportion [Array<Float>] The ratio between the AI and human frequency of each pattern
    # @param source [Array<Integer>] The source of each pattern (1 = AI, 2 = humanizer)
    def initialize(ai_count: nil, human_count: nil, proportion: nil, source: nil)
      @ai_count = ai_count
      @human_count = human_count
      @proportion = proportion
      @source = source
    end

    # Create instance from JSON hash
    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        ai_count: json_hash['aiCount'],
        human_count: json_hash['humanCount'],
        proportion: json_hash['proportion'],
        source: json_hash['source']
      )
    end

    # Convert to JSON
    def to_json(*args)
      {
        'aiCount' => @ai_count,
        'humanCount' => @human_count,
        'proportion' => @proportion,
        'source' => @source
      }.compact.to_json(*args)
    end
  end
end
