# frozen_string_literal: true

module Copyleaks
  # The positions of a classified part of the text.
  class CopyleaksAiTextDetectionMatchModel
    # In the text version of the document.
    attr_accessor :text

    # In the HTML version of the document. Present only for HTML sources.
    attr_accessor :html

    def initialize(text: nil, html: nil)
      @text = text
      @html = html
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      text = CopyleaksAiTextDetectionMatchTextModel.from_json(json_hash['text']) if json_hash['text']
      html = CopyleaksAiTextDetectionMatchTextModel.from_json(json_hash['html']) if json_hash['html']

      new(text: text, html: html)
    end

    def to_json(*args)
      {
        'text' => @text,
        'html' => @html
      }.compact.to_json(*args)
    end
  end
end
