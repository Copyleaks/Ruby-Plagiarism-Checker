# frozen_string_literal: true

module Copyleaks
  # Summary of the AI text detection analysis.
  class CopyleaksAiTextDetectionSummaryModel
    # Share of the text classified as human-written, 0.0-1.0.
    attr_accessor :human

    # Share of the text classified as AI-generated, 0.0-1.0.
    attr_accessor :ai

    def initialize(human: nil, ai: nil)
      @human = human
      @ai = ai
    end

    # Accepts camelCase and PascalCase keys; sandbox scans send PascalCase.
    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        human: json_hash.key?('human') ? json_hash['human'] : json_hash['Human'],
        ai: json_hash.key?('ai') ? json_hash['ai'] : json_hash['Ai']
      )
    end

    def to_json(*args)
      {
        'human' => @human,
        'ai' => @ai
      }.compact.to_json(*args)
    end
  end
end
