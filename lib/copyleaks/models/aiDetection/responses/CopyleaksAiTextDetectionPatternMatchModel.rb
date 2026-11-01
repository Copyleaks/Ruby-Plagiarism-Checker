# frozen_string_literal: true

module Copyleaks
  # Character and word positions of the AI patterns.
  class CopyleaksAiTextDetectionPatternMatchModel
    # May be nil.
    attr_accessor :chars

    attr_accessor :words

    def initialize(chars: nil, words: nil)
      @chars = chars
      @words = words
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      chars = CopyleaksAiTextDetectionPositionsModel.from_json(json_hash['chars']) if json_hash['chars']
      words = CopyleaksAiTextDetectionPositionsModel.from_json(json_hash['words']) if json_hash['words']

      new(chars: chars, words: words)
    end

    def to_json(*args)
      {
        'chars' => @chars,
        'words' => @words
      }.compact.to_json(*args)
    end
  end
end
