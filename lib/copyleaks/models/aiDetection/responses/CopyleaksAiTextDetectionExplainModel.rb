# frozen_string_literal: true

module Copyleaks
  # AI Logic explanation of the AI text detection result.
  class CopyleaksAiTextDetectionExplainModel
    attr_accessor :patterns

    def initialize(patterns: nil)
      @patterns = patterns
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      patterns = CopyleaksAiTextDetectionPatternsModel.from_json(json_hash['patterns']) if json_hash['patterns']

      new(patterns: patterns)
    end

    def to_json(*args)
      {
        'patterns' => @patterns
      }.compact.to_json(*args)
    end
  end
end
