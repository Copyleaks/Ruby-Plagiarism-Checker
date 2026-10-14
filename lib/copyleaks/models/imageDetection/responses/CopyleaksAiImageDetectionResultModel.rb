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
  # RLE-encoded mask data for AI-detected regions.
  class CopyleaksAiImageDetectionResultModel
    # Start positions of AI-detected segments in the flattened image array.
    attr_accessor :starts

    # Lengths of AI-detected segments corresponding to each start position.
    attr_accessor :lengths

    # Present only when the request set maskType to "heatmap": one confidence band (0 lowest to 4 highest)
    # per segment, aligned with starts and lengths. nil for the default binary mask.
    attr_accessor :labels

    # Initialize a new CopyleaksAiImageDetectionResultModel
    #
    # @param starts [Array<Integer>] Start positions of AI-detected segments in the flattened image array
    # @param lengths [Array<Integer>] Lengths of AI-detected segments corresponding to each start position
    # @param labels [Array<Integer>] Heatmap confidence band per segment (heatmap mask only)
    def initialize(starts: nil, lengths: nil, labels: nil)
      @starts = starts
      @lengths = lengths
      @labels = labels
    end

    # Create instance from JSON hash
    def self.from_json(json_hash)
      return nil if json_hash.nil?

      new(
        starts: json_hash['starts'],
        lengths: json_hash['lengths'],
        labels: json_hash['labels']
      )
    end

    # Convert to JSON
    def to_json(*args)
      hash = {
        'starts' => @starts,
        'lengths' => @lengths
      }
      hash['labels'] = @labels unless @labels.nil?
      hash.to_json(*args)
    end
  end
end