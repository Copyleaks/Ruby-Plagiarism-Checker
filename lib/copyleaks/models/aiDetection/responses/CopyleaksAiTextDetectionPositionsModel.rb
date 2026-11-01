# frozen_string_literal: true

module Copyleaks
  # Start positions and lengths of text segments.
  class CopyleaksAiTextDetectionPositionsModel
    attr_accessor :starts

    # Aligned with starts.
    attr_accessor :lengths

    # Present only for HTML positions.
    attr_accessor :group_ids

    def initialize(starts: nil, lengths: nil, group_ids: nil)
      @starts = starts
      @lengths = lengths
      @group_ids = group_ids
    end

    # Accepts camelCase and PascalCase keys; sandbox scans send PascalCase.
    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        starts: json_hash.key?('starts') ? json_hash['starts'] : json_hash['Starts'],
        lengths: json_hash.key?('lengths') ? json_hash['lengths'] : json_hash['Lengths'],
        group_ids: json_hash.key?('groupIds') ? json_hash['groupIds'] : json_hash['GroupIds']
      )
    end

    def to_json(*args)
      {
        'starts' => @starts,
        'lengths' => @lengths,
        'groupIds' => @group_ids
      }.compact.to_json(*args)
    end
  end
end
