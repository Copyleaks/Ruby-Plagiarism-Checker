# frozen_string_literal: true

module Copyleaks
  # A classified section of the text.
  class CopyleaksAiTextDetectionResultModel
    # 1 = human-written, 2 = AI-generated.
    attr_accessor :classification

    # Deprecated by the server; planned for removal.
    attr_accessor :probability

    # Positions of the text in this section.
    attr_accessor :matches

    def initialize(classification: nil, probability: nil, matches: nil)
      @classification = classification
      @probability = probability
      @matches = matches
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      matches = json_hash['matches'].map { |m| CopyleaksAiTextDetectionMatchModel.from_json(m) } if json_hash['matches'].is_a?(Array)

      new(
        classification: json_hash['classification'],
        probability: json_hash['probability'],
        matches: matches
      )
    end

    def to_json(*args)
      {
        'classification' => @classification,
        'probability' => @probability,
        'matches' => @matches
      }.compact.to_json(*args)
    end
  end
end
