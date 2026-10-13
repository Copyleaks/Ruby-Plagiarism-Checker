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
  # AI text detection result.
  # This is the object carried, as a JSON string, in the additionalData of the
  # 'suspected-ai-text' alert of the completed webhook.
  class CopyleaksAiTextDetectionResponseModel
    # The version of the AI detection model used for the analysis.
    attr_accessor :model_version

    # The classified sections of the text.
    attr_accessor :results

    # Summary of the AI detection analysis.
    attr_accessor :summary

    # The translation provider used when the text was machine-translated to English.
    # 0 = none, 1 = Google Translate, 2 = Helsinki, 3 = Azure.
    attr_accessor :translation_provider

    # The full English translation of the text. Present only when the text was machine-translated.
    attr_accessor :translation

    # AI Logic explanation. Present only when AI Logic (explain) was enabled.
    attr_accessor :explain

    # Initialize a new CopyleaksAiTextDetectionResponseModel
    #
    # @param model_version [String] The version of the AI detection model used for the analysis
    # @param results [Array<CopyleaksAiTextDetectionResultModel>] The classified sections of the text
    # @param summary [CopyleaksAiTextDetectionSummaryModel] Summary of the AI detection analysis
    # @param translation_provider [Integer] The translation provider (0 = none, 1 = Google Translate, 2 = Helsinki, 3 = Azure)
    # @param translation [String] The full English translation of the text, when it was machine-translated
    # @param explain [CopyleaksAiTextDetectionExplainModel] AI Logic explanation, when AI Logic was enabled
    def initialize(model_version: nil, results: nil, summary: nil, translation_provider: nil, translation: nil, explain: nil)
      @model_version = model_version
      @results = results
      @summary = summary
      @translation_provider = translation_provider
      @translation = translation
      @explain = explain
    end

    # Create instance from JSON hash
    #
    # Unknown fields are ignored and missing fields are left nil.
    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      results = json_hash['results'].map { |r| CopyleaksAiTextDetectionResultModel.from_json(r) } if json_hash['results'].is_a?(Array)
      summary = CopyleaksAiTextDetectionSummaryModel.from_json(json_hash['summary']) if json_hash['summary']
      explain = CopyleaksAiTextDetectionExplainModel.from_json(json_hash['explain']) if json_hash['explain']

      new(
        model_version: json_hash['modelVersion'],
        results: results,
        summary: summary,
        translation_provider: json_hash['translationProvider'],
        translation: json_hash['translation'],
        explain: explain
      )
    end

    # Convert to JSON
    def to_json(*args)
      {
        'modelVersion' => @model_version,
        'results' => @results,
        'summary' => @summary,
        'translationProvider' => @translation_provider,
        'translation' => @translation,
        'explain' => @explain
      }.compact.to_json(*args)
    end
  end
end
