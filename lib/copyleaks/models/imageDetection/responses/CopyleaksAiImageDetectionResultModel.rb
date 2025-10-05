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

    # Initialize a new CopyleaksAiImageDetectionResultModel
    #
    # @param starts [Array<Integer>] Start positions of AI-detected segments in the flattened image array
    # @param lengths [Array<Integer>] Lengths of AI-detected segments corresponding to each start position
    def initialize(starts: nil, lengths: nil)
      @starts = starts
      @lengths = lengths
    end

    # Create instance from JSON hash
    def self.from_json(json_hash)
      return nil if json_hash.nil?

      new(
        starts: json_hash['starts'],
        lengths: json_hash['lengths']
      )
    end

    # Convert to JSON
    def to_json(*args)
      {
        'starts' => @starts,
        'lengths' => @lengths
      }.to_json(*args)
    end
  end
end