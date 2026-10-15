# frozen_string_literal: true

module Copyleaks
  # RLE-encoded mask data for AI-detected regions.
  class CopyleaksAiImageDetectionResultModel
    # Start of each AI-detected segment in the flattened image array.
    attr_accessor :starts

    # Aligned with starts.
    attr_accessor :lengths

    # Heatmap mask only: one confidence band per segment, 0 (lowest) to 4 (highest). nil for the binary mask.
    attr_accessor :labels

    def initialize(starts: nil, lengths: nil, labels: nil)
      @starts = starts
      @lengths = lengths
      @labels = labels
    end

    def self.from_json(json_hash)
      return nil if json_hash.nil?

      new(
        starts: json_hash['starts'],
        lengths: json_hash['lengths'],
        labels: json_hash['labels']
      )
    end

    def to_json(*args)
      hash = {
        'starts' => @starts,
        'lengths' => @lengths
      }
      hash['labels'] = @labels unless @labels.nil?
      hash.to_json(*args)
    end
  end
end