require 'json'
require 'time'

module Copyleaks
  class TextModerationScannedDocument
    attr_accessor :scan_id, :total_words, :total_excluded, :actual_credits, :expected_credits, :creation_time

    # @param creation_time [Time, String, nil] When the scan was created.
    def initialize(scan_id: '', total_words: 0, total_excluded: 0, actual_credits: 0, expected_credits: 0, creation_time: nil)
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
        creationTime: @creation_time.respond_to?(:iso8601) ? @creation_time.iso8601 : @creation_time
      }.to_json(options)
    end

    # @param json [Hash, String] A parsed Hash or a JSON String.
    def self.from_json(json)
      data = TextModerationJson.to_hash(json)
      return nil if data.nil?

      creation_time = TextModerationJson.get(data, 'creationTime')
      new(
        scan_id: TextModerationJson.get(data, 'scanId'),
        total_words: TextModerationJson.get(data, 'totalWords'),
        total_excluded: TextModerationJson.get(data, 'totalExcluded'),
        actual_credits: TextModerationJson.get(data, 'actualCredits'),
        expected_credits: TextModerationJson.get(data, 'expectedCredits'),
        creation_time: creation_time.is_a?(String) ? Time.parse(creation_time) : creation_time
      )
    end
  end
end
