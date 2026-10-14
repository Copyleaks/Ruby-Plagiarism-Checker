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
  # Optional metadata extracted from the image.
  class CopyleaksImageMetadataModel
    # Timestamp when the image was created (if available).
    attr_accessor :issued_time

    # The AI service or tool that created the image (if detected).
    attr_accessor :issued_by

    # The application or device used to create the image.
    attr_accessor :app_or_device_used

    # A summary of how the image was generated (if available).
    attr_accessor :content_summary

    # Initialize a new CopyleaksImageMetadataModel
    #
    # @param issued_time [String] Timestamp when the image was created (if available)
    # @param issued_by [String] The AI service or tool that created the image (if detected)
    # @param app_or_device_used [String] The application or device used to create the image
    # @param content_summary [String] A summary of how the image was generated (if available)
    def initialize(issued_time: nil, issued_by: nil, app_or_device_used: nil, content_summary: nil)
      @issued_time = issued_time
      @issued_by = issued_by
      @app_or_device_used = app_or_device_used
      @content_summary = content_summary
    end

    # Create instance from JSON hash
    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        issued_time: json_hash['issuedTime'],
        issued_by: json_hash['issuedBy'],
        app_or_device_used: json_hash['appOrDeviceUsed'],
        content_summary: json_hash['contentSummary']
      )
    end

    # Convert to JSON
    def to_json(*args)
      hash = {
        'issuedTime' => @issued_time,
        'issuedBy' => @issued_by,
        'appOrDeviceUsed' => @app_or_device_used
      }
      hash['contentSummary'] = @content_summary unless @content_summary.nil?
      hash.to_json(*args)
    end
  end
end