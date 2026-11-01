# frozen_string_literal: true

module Copyleaks
  # Information about the analyzed image.
  class CopyleaksAiImageDetectionImageInfoModel
    attr_accessor :shape

    attr_accessor :metadata

    def initialize(shape: nil, metadata: nil)
      @shape = shape
      @metadata = metadata
    end

    def self.from_json(json_hash)
      return nil if json_hash.nil?

      shape = CopyleaksImageShapeModel.from_json(json_hash['shape']) if json_hash['shape']
      metadata = CopyleaksImageMetadataModel.from_json(json_hash['metadata']) if json_hash['metadata']

      new(shape: shape, metadata: metadata)
    end

    def to_json(*args)
      {
        'shape' => @shape ? JSON.parse(@shape.to_json) : nil,
        'metadata' => @metadata ? JSON.parse(@metadata.to_json) : nil
      }.to_json(*args)
    end
  end
end