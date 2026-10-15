# frozen_string_literal: true

module Copyleaks
  # Metadata about the AI image detection scan operation.
  class CopyleaksAiImageDetectionScannedDocumentModel
    attr_accessor :scan_id

    attr_accessor :actual_credits

    attr_accessor :expected_credits

    # ISO 8601 timestamp.
    attr_accessor :creation_time

    def initialize(scan_id: nil, actual_credits: nil, expected_credits: nil, creation_time: nil)
      @scan_id = scan_id
      @actual_credits = actual_credits
      @expected_credits = expected_credits
      @creation_time = creation_time
    end

    def self.from_json(json_hash)
      return nil if json_hash.nil?

      new(
        scan_id: json_hash['scanId'],
        actual_credits: json_hash['actualCredits'],
        expected_credits: json_hash['expectedCredits'],
        creation_time: json_hash['creationTime']
      )
    end

    def to_json(*args)
      {
        'scanId' => @scan_id,
        'actualCredits' => @actual_credits,
        'expectedCredits' => @expected_credits,
        'creationTime' => @creation_time
      }.to_json(*args)
    end
  end
end