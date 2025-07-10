require 'json'
module Copyleaks

class CopyleaksTextModerationResponseModel
  attr_accessor :moderations, :legend, :scanned_document

  # @param moderations [ModerationsModel] Moderated text segments detected in the input text.
  # @param legend [Array<TextModerationsLegend>] An array that provides a lookup for the labels referenced by their numerical indices in the `text.chars.labels` array. Each object within this legend array defines a specific label that was used in the scan.
  # @param scanned_document [TextModerationScannedDocument] General information about the scanned document.
  def initialize(moderations: ModerationsModel.new, legend: [], scanned_document: TextModerationScannedDocument.new, **_ignored)
    @moderations = moderations
    @legend = legend
    @scanned_document = scanned_document
  end


  def to_json(options = {})
    {
      moderations: @moderations ? JSON.parse(@moderations.to_json) : nil,
      legend: @legend.map(&:to_json).map { |l| JSON.parse(l) },
      scannedDocument: @scanned_document ? JSON.parse(@scanned_document.to_json) : nil
    }.to_json(options)
  end


  def self.from_json(json_string)
    data = JSON.parse(json_string, symbolize_names: true)
    new(
      moderations: data[:moderations] ? ModerationsModel.from_json(data[:moderations].to_json) : nil,
      legend: data[:legend].map { |l| TextModerationsLegend.from_json(l.to_json) },
      scanned_document: data[:scannedDocument] ? TextModerationScannedDocument.from_json(data[:scannedDocument].to_json) : nil
    )
  end
end

end
