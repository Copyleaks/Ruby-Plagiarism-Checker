# frozen_string_literal: true

module Copyleaks
  # Dimensions of the analyzed image, in pixels.
  class CopyleaksImageShapeModel
    attr_accessor :height

    attr_accessor :width

    def initialize(height: nil, width: nil)
      @height = height
      @width = width
    end

    def self.from_json(json_hash)
      return nil if json_hash.nil?

      new(
        height: json_hash['height'],
        width: json_hash['width']
      )
    end

    def to_json(*args)
      {
        'height' => @height,
        'width' => @width
      }.to_json(*args)
    end
  end
end