require 'json'

module Copyleaks
  # Builds the text moderation models from a parsed Hash (String or Symbol keys) or a JSON String.
  module TextModerationJson
    def self.to_hash(json)
      data = json.is_a?(String) ? JSON.parse(json) : json
      data.is_a?(Hash) ? data : nil
    end

    def self.get(data, key)
      data.key?(key) ? data[key] : data[key.to_sym]
    end
  end

  class CopyleaksTextModerationResponseModel
    attr_accessor :moderations, :legend, :scanned_document, :model_version

    # @param moderations [ModerationsModel] The flagged character ranges.
    # @param legend [Array<TextModerationsLegend>] Maps label indexes to label ids.
    # @param scanned_document [TextModerationScannedDocument] Metadata about the scan.
    # @param model_version [String] The version of the moderation model used.
    def initialize(moderations: ModerationsModel.new, legend: [], scanned_document: TextModerationScannedDocument.new,
                   model_version: nil, **_ignored)
      @moderations = moderations
      @legend = legend
      @scanned_document = scanned_document
      @model_version = model_version
    end

    def to_json(options = {})
      hash = {
        moderations: @moderations ? JSON.parse(@moderations.to_json) : nil,
        legend: (@legend || []).map { |l| JSON.parse(l.to_json) },
        scannedDocument: @scanned_document ? JSON.parse(@scanned_document.to_json) : nil
      }
      hash[:modelVersion] = @model_version unless @model_version.nil?
      hash.to_json(options)
    end

    # @param json [Hash, String] The client result (a Hash) or the raw JSON String.
    def self.from_json(json)
      data = TextModerationJson.to_hash(json)
      return nil if data.nil?

      moderations = TextModerationJson.get(data, 'moderations')
      legend = TextModerationJson.get(data, 'legend')
      scanned_document = TextModerationJson.get(data, 'scannedDocument')
      new(
        moderations: moderations ? ModerationsModel.from_json(moderations) : nil,
        legend: (legend || []).map { |l| TextModerationsLegend.from_json(l) },
        scanned_document: scanned_document ? TextModerationScannedDocument.from_json(scanned_document) : nil,
        model_version: TextModerationJson.get(data, 'modelVersion')
      )
    end
  end
end
