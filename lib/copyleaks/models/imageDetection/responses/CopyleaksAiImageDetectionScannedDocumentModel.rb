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
  # Metadata about the AI image detection scan operation.
  class CopyleaksAiImageDetectionScannedDocumentModel
    # The unique identifier for this scan.
    attr_accessor :scan_id

    # The actual number of credits consumed by this scan.
    attr_accessor :actual_credits

    # The expected number of credits for this scan.
    attr_accessor :expected_credits

    # ISO 8601 timestamp of when the scan was created.
    attr_accessor :creation_time

    # Initialize a new CopyleaksAiImageDetectionScannedDocumentModel
    #
    # @param scan_id [String] The unique identifier for this scan
    # @param actual_credits [Integer] The actual number of credits consumed by this scan
    # @param expected_credits [Integer] The expected number of credits for this scan
    # @param creation_time [String] ISO 8601 timestamp of when the scan was created
    def initialize(scan_id: nil, actual_credits: nil, expected_credits: nil, creation_time: nil)
      @scan_id = scan_id
      @actual_credits = actual_credits
      @expected_credits = expected_credits
      @creation_time = creation_time
    end

    # Create instance from JSON hash
    def self.from_json(json_hash)
      return nil if json_hash.nil?

      new(
        scan_id: json_hash['scanId'],
        actual_credits: json_hash['actualCredits'],
        expected_credits: json_hash['expectedCredits'],
        creation_time: json_hash['creationTime']
      )
    end

    # Convert to JSON
    def to_json(*args)
      {
        'scanId' => @scan_id,
        'actualCredits' => @actual_credits,
        'expectedCredits' => @expected_credits,
        'creationTime' => @creation_time
      }.to_json(*args)
    end
  end
end