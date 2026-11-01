# frozen_string_literal: true

module Copyleaks
  # AI text detection result.
  # This is the object carried, as a JSON string, in the additionalData of the
  # 'suspected-ai-text' alert of the completed webhook.
  class CopyleaksAiTextDetectionResponseModel
    attr_accessor :model_version

    # The classified sections of the text.
    attr_accessor :results

    attr_accessor :summary

    # Machine translation to English: 0 = none, 1 = Google Translate, 2 = Helsinki, 3 = Azure.
    attr_accessor :translation_provider

    # The full English translation. Present only when the text was machine-translated.
    attr_accessor :translation

    # AI Logic explanation. Present only when AI Logic (explain) was enabled.
    attr_accessor :explain

    attr_accessor :scanned_document

    def initialize(model_version: nil, results: nil, summary: nil, translation_provider: nil, translation: nil, explain: nil,
                   scanned_document: nil)
      @model_version = model_version
      @results = results
      @summary = summary
      @translation_provider = translation_provider
      @translation = translation
      @explain = explain
      @scanned_document = scanned_document
    end

    # Unknown fields are ignored; missing fields are left nil.
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
        explain: explain,
        scanned_document: CopyleaksAiTextDetectionScannedDocumentModel.from_json(json_hash['scannedDocument'])
      )
    end

    def to_json(*args)
      {
        'modelVersion' => @model_version,
        'results' => @results,
        'summary' => @summary,
        'translationProvider' => @translation_provider,
        'translation' => @translation,
        'explain' => @explain,
        'scannedDocument' => @scanned_document
      }.compact.to_json(*args)
    end
  end
end
