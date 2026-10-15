module Copyleaks
  # One object located in the image, with its run-length encoded segmentation mask.
  class CopyleaksAiImageDetectedObjectModel
    # The object name from the request, for example "face".
    attr_accessor :object

    # RLE mask (starts and lengths) in the coordinate space of imageInfo.shape.
    attr_accessor :mask

    def initialize(object: nil, mask: nil)
      @object = object
      @mask = mask
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        object: json_hash['object'],
        mask: CopyleaksAiImageDetectionResultModel.from_json(json_hash['mask'])
      )
    end

    def to_json(*args)
      {
        'object' => @object,
        'mask' => @mask ? JSON.parse(@mask.to_json) : nil
      }.to_json(*args)
    end
  end
end
