require 'json'
require 'date'
module Copyleaks

class TextModerationScannedDocument
  attr_accessor :scan_id, :total_words, :total_excluded, :actual_credits, :expected_credits, :creation_time

  def initialize(scan_id: '', total_words: 0, total_excluded: 0, actual_credits: 0, expected_credits: 0, creation_time: Time.utc.now)
    @scan_id = scan_id
    @total_words = total_words
    @total_excluded = total_excluded
    @actual_credits = actual_credits
    @expected_credits = expected_credits
    @creation_time = creation_time
  end


  def to_json(options = {})
    {
      scanId: @scan_id,
      totalWords: @total_words,
      totalExcluded: @total_excluded,
      actualCredits: @actual_credits,
      expectedCredits: @expected_credits,
      creationTime: @creation_time.iso8601
    }.to_json(options)
  end

  def self.from_json(json_string)
    data = JSON.parse(json_string, symbolize_names: true)
    new(
      scan_id: data[:scanId],
      total_words: data[:totalWords],
      total_excluded: data[:totalExcluded],
      actual_credits: data[:actualCredits],
      expected_credits: data[:expectedCredits],
      creation_time: Time.parse(data[:creationTime]) 
    )
  end
end
end
