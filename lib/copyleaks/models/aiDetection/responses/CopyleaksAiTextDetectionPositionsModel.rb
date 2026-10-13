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
  # Start positions and lengths of text segments.
  class CopyleaksAiTextDetectionPositionsModel
    # Start positions of the segments.
    attr_accessor :starts

    # Lengths of the segments, matching each start position.
    attr_accessor :lengths

    # Group ids of the segments. Present only for HTML positions.
    attr_accessor :group_ids

    # Initialize a new CopyleaksAiTextDetectionPositionsModel
    #
    # @param starts [Array<Integer>] Start positions of the segments
    # @param lengths [Array<Integer>] Lengths of the segments, matching each start position
    # @param group_ids [Array<Integer>] Group ids of the segments (HTML positions only)
    def initialize(starts: nil, lengths: nil, group_ids: nil)
      @starts = starts
      @lengths = lengths
      @group_ids = group_ids
    end

    # Create instance from JSON hash
    #
    # Accepts both camelCase ('starts') and PascalCase ('Starts') keys;
    # sandbox scans send PascalCase keys.
    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        starts: json_hash.key?('starts') ? json_hash['starts'] : json_hash['Starts'],
        lengths: json_hash.key?('lengths') ? json_hash['lengths'] : json_hash['Lengths'],
        group_ids: json_hash.key?('groupIds') ? json_hash['groupIds'] : json_hash['GroupIds']
      )
    end

    # Convert to JSON
    def to_json(*args)
      {
        'starts' => @starts,
        'lengths' => @lengths,
        'groupIds' => @group_ids
      }.compact.to_json(*args)
    end
  end
end
