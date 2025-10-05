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
  # Response model for Copyleaks AI image detection analysis.
  # Contains the AI detection results, image information, and scan metadata.
  class CopyleaksAiImageDetectionResponseModel
    # The version of the AI detection model used for analysis.
    attr_accessor :model

    # RLE-encoded mask data containing arrays of start positions and lengths for AI-detected regions.
    attr_accessor :result

    # Summary statistics of the AI detection analysis.
    attr_accessor :summary

    # Information about the analyzed image.
    attr_accessor :image_info

    # Metadata about the scan operation.
    attr_accessor :scanned_document

    # Initialize a new CopyleaksAiImageDetectionResponseModel
    #
    # @param model [String] The version of the AI detection model used for analysis
    # @param result [CopyleaksAiImageDetectionResultModel] RLE-encoded mask data containing arrays of start positions and lengths for AI-detected regions
    # @param summary [CopyleaksAiImageDetectionSummaryModel] Summary statistics of the AI detection analysis
    # @param image_info [CopyleaksAiImageDetectionImageInfoModel] Information about the analyzed image
    # @param scanned_document [CopyleaksAiImageDetectionScannedDocumentModel] Metadata about the scan operation
    def initialize(model: nil, result: nil, summary: nil, image_info: nil, scanned_document: nil)
      @model = model
      @result = result
      @summary = summary
      @image_info = image_info
      @scanned_document = scanned_document
    end

    # Create instance from JSON hash
    def self.from_json(json_hash)
      return nil if json_hash.nil?

      result = CopyleaksAiImageDetectionResultModel.from_json(json_hash['result']) if json_hash['result']
      summary = CopyleaksAiImageDetectionSummaryModel.from_json(json_hash['summary']) if json_hash['summary']
      image_info = CopyleaksAiImageDetectionImageInfoModel.from_json(json_hash['imageInfo']) if json_hash['imageInfo']
      scanned_document = CopyleaksAiImageDetectionScannedDocumentModel.from_json(json_hash['scannedDocument']) if json_hash['scannedDocument']

      new(
        model: json_hash['model'],
        result: result,
        summary: summary,
        image_info: image_info,
        scanned_document: scanned_document
      )
    end

    # Convert to JSON
    def to_json(*args)
      {
        'model' => @model,
        'result' => @result ? JSON.parse(@result.to_json) : nil,
        'summary' => @summary ? JSON.parse(@summary.to_json) : nil,
        'imageInfo' => @image_info ? JSON.parse(@image_info.to_json) : nil,
        'scannedDocument' => @scanned_document ? JSON.parse(@scanned_document.to_json) : nil
      }.to_json(*args)
    end
  end
end