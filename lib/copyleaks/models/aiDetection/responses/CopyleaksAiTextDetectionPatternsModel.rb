# frozen_string_literal: true

module Copyleaks
  # The AI patterns found in the text.
  class CopyleaksAiTextDetectionPatternsModel
    attr_accessor :statistics

    # In the text version of the document.
    attr_accessor :text

    # In the HTML version of the document. Present only for HTML sources.
    attr_accessor :html

    def initialize(statistics: nil, text: nil, html: nil)
      @statistics = statistics
      @text = text
      @html = html
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      statistics = CopyleaksAiTextDetectionPatternStatisticsModel.from_json(json_hash['statistics']) if json_hash['statistics']
      text = CopyleaksAiTextDetectionPatternMatchModel.from_json(json_hash['text']) if json_hash['text']
      html = CopyleaksAiTextDetectionPatternMatchModel.from_json(json_hash['html']) if json_hash['html']

      new(statistics: statistics, text: text, html: html)
    end

    def to_json(*args)
      {
        'statistics' => @statistics,
        'text' => @text,
        'html' => @html
      }.compact.to_json(*args)
    end
  end
end
