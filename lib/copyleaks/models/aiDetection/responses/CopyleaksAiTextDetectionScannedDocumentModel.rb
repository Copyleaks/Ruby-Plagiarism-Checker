module Copyleaks
  # Metadata about an AI Text Detection scan.
  class CopyleaksAiTextDetectionScannedDocumentModel
    attr_accessor :scan_id, :total_words, :total_excluded, :actual_credits, :expected_credits, :creation_time

    def initialize(scan_id: nil, total_words: nil, total_excluded: nil, actual_credits: nil, expected_credits: nil,
                   creation_time: nil)
      @scan_id = scan_id
      @total_words = total_words
      @total_excluded = total_excluded
      @actual_credits = actual_credits
      @expected_credits = expected_credits
      @creation_time = creation_time
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        scan_id: json_hash['scanId'],
        total_words: json_hash['totalWords'],
        total_excluded: json_hash['totalExcluded'],
        # The API sends actualCredits; credits is accepted too.
        actual_credits: json_hash.key?('actualCredits') ? json_hash['actualCredits'] : json_hash['credits'],
        expected_credits: json_hash['expectedCredits'],
        creation_time: json_hash['creationTime']
      )
    end

    def to_json(*args)
      {
        'scanId' => @scan_id,
        'totalWords' => @total_words,
        'totalExcluded' => @total_excluded,
        'actualCredits' => @actual_credits,
        'expectedCredits' => @expected_credits,
        'creationTime' => @creation_time
      }.compact.to_json(*args)
    end
  end
end
