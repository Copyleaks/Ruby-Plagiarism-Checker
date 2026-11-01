# frozen_string_literal: true

module Copyleaks
  # Summary statistics of the AI detection analysis.
  class CopyleaksAiImageDetectionSummaryModel
    # Share of pixels suspected to be human-created, 0.0-1.0.
    attr_accessor :human

    # Share of pixels suspected to be AI-generated, 0.0-1.0.
    attr_accessor :ai

    def initialize(human: nil, ai: nil)
      @human = human
      @ai = ai
    end

    def self.from_json(json_hash)
      return nil if json_hash.nil?

      new(
        human: json_hash['human'],
        ai: json_hash['ai']
      )
    end

    def to_json(*args)
      {
        'human' => @human,
        'ai' => @ai
      }.to_json(*args)
    end
  end
end