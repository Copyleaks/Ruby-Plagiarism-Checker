require 'json'
module Copyleaks

class CopyleaksTextModerationResponseModel
  attr_accessor :moderations, :legend, :scanned_document

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
