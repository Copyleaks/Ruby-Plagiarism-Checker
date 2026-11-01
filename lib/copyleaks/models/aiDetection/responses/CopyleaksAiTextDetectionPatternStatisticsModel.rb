# frozen_string_literal: true

module Copyleaks
  # Statistics of the AI patterns found in the text.
  # Each array has one entry per pattern, in the same order.
  class CopyleaksAiTextDetectionPatternStatisticsModel
    # How often each pattern appears in AI-generated text.
    attr_accessor :ai_count

    # How often each pattern appears in human-written text.
    attr_accessor :human_count

    # The ratio between the AI and human frequency of each pattern.
    attr_accessor :proportion

    # The source of each pattern. 1 = AI, 2 = humanizer.
    attr_accessor :source

    def initialize(ai_count: nil, human_count: nil, proportion: nil, source: nil)
      @ai_count = ai_count
      @human_count = human_count
      @proportion = proportion
      @source = source
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        ai_count: json_hash['aiCount'],
        human_count: json_hash['humanCount'],
        proportion: json_hash['proportion'],
        source: json_hash['source']
      )
    end

    def to_json(*args)
      {
        'aiCount' => @ai_count,
        'humanCount' => @human_count,
        'proportion' => @proportion,
        'source' => @source
      }.compact.to_json(*args)
    end
  end
end
