#
#  The MIT License(MIT)
#
#  Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
# =


module Copyleaks
  # Request model for Copyleaks AI image detection (synchronous check).
  #
  # The image can be sent two ways:
  # * as base64 in a JSON body: pass the base64 string as the first argument;
  # * as raw bytes in a multipart/form-data body (recommended, no base64 overhead):
  #   pass nil as the first argument and the bytes as image:, for example image: File.binread(path).
  class CopyleaksAiImageDetectionRequestModel
    VALID_EXTENSIONS = %w[.png .bmp .jpg .jpeg .webp .heic .heif .avif].freeze
    FILENAME_MIN_LENGTH = 5
    FILENAME_MAX_LENGTH = 254
    MAX_OBJECT_DETECTION_ENTRIES = 3
    MAX_OBJECT_NAME_LENGTH = 32

    attr_accessor :base64, :file_name, :model, :sandbox, :mask_type, :object_detection, :image

    # @param base64 [String, nil] The base64-encoded image. nil when image: is used instead.
    # @param file_name [String] The name of the image file including its extension.
    # @param model [String] The AI detection model, for example CopyleaksAiImageDetectionModels::AI_IMAGE_1_ULTRA.
    # @param sandbox [Boolean, nil] Use sandbox mode to test your integration without consuming credits.
    #   Leave nil to omit the field (server default: false).
    # @param mask_type [String, nil] The detection mask to return: CopyleaksAiImageMaskTypes::BINARY (server default),
    #   HEATMAP (adds result.labels, a confidence band per segment) or NONE (no result object, scores only).
    # @param object_detection [Array<String>, nil] Up to 3 objects to locate in the image, for example ['face', 'hand'].
    #   Each name is 1 to 32 characters. The response then includes detectedObjects.
    # @param image [String, IO, nil] The raw image bytes (or an IO to read them from). When set, the image is
    #   uploaded as multipart/form-data and base64 must be nil.
    def initialize(base64, file_name, model, sandbox = nil, mask_type: nil, object_detection: nil, image: nil)
      if !base64.nil? && !image.nil?
        raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionRequestModel - pass either base64 or image:, not both'
      end
      if !image.nil? && !image.is_a?(String) && !image.respond_to?(:read)
        raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionRequestModel - image - image must be a binary String or an IO'
      end
      if !sandbox.nil? && ![true, false].include?(sandbox)
        raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionRequestModel - sandbox - sandbox must be of type Boolean'
      end
      if !mask_type.nil? && !mask_type.is_a?(String)
        raise ArgumentError, 'Copyleaks::CopyleaksAiImageDetectionRequestModel - mask_type - mask_type must be of type String'
      end

      @base64 = base64
      @file_name = file_name
      @model = model
      @sandbox = sandbox
      @mask_type = mask_type
      @object_detection = self.class.normalize_object_detection(object_detection)
      @image = image
    end

    # True when the image is sent as multipart/form-data (raw bytes given with image:).
    def multipart?
      !@image.nil?
    end

    # Convert the model to a hash for JSON serialization. Fields that are nil are left out.
    #
    # @return [Hash] Hash representation of the model
    def to_hash
      {
        base64: @base64,
        filename: @file_name,
        model: @model,
        sandbox: @sandbox,
        maskType: @mask_type,
        objectDetection: @object_detection
      }.reject { |_k, v| v.nil? }
    end

    # Convert the model to JSON
    #
    # @return [String] JSON representation of the model
    def to_json(*args)
      to_hash.to_json(*args)
    end

    # Build the multipart/form-data body used when image: is set.
    # @return [Copyleaks::MultipartForm]
    def to_multipart
      form = MultipartForm.new
      form.add_file('image', @image, @file_name.to_s)
      form.add_field('filename', @file_name)
      form.add_field('model', @model) unless @model.nil?
      form.add_field('sandbox', @sandbox) unless @sandbox.nil?
      form.add_field('maskType', @mask_type) unless @mask_type.nil?
      # Multipart requests carry the object list as one JSON-encoded field.
      form.add_field('objectDetection', @object_detection.to_json) unless @object_detection.nil?
      form
    end

    # Optional client-side checks. The client does not call this method, so the server stays the
    # final judge of what it accepts.
    #
    # Requirements (from the API reference):
    # - Image: minimum 512x512px, maximum 6000x4500px (27 megapixels), less than 32MB
    # - Formats: PNG, JPEG, BMP, WebP, HEIC/HEIF, AVIF
    # - File name: 5 to 254 characters, with a supported extension
    #
    # @raise [ArgumentError] If required fields are missing or invalid
    def validate!
      if @image.nil? && (@base64.nil? || @base64.empty?)
        raise ArgumentError, 'base64 or image is required'
      end
      raise ArgumentError, 'file_name is required' if @file_name.nil? || @file_name.empty?
      raise ArgumentError, 'model is required' if @model.nil? || @model.empty?

      validate_file_name!
      validate_file_size!
    end

    # Accepts ['face', 'hand'] or [{ object: 'face' }] and returns [{ object: 'face' }, ...].
    def self.normalize_object_detection(list)
      return nil if list.nil?

      unless list.is_a?(Array) && list.length <= MAX_OBJECT_DETECTION_ENTRIES
        raise ArgumentError, "object_detection must be an Array of at most #{MAX_OBJECT_DETECTION_ENTRIES} entries"
      end

      list.map do |entry|
        name = entry.is_a?(Hash) ? (entry[:object] || entry['object']) : entry
        unless name.is_a?(String) && !name.empty? && name.length <= MAX_OBJECT_NAME_LENGTH
          raise ArgumentError, "object_detection entries must be non-empty Strings of at most #{MAX_OBJECT_NAME_LENGTH} characters"
        end

        { object: name }
      end
    end

    private

    # Validate file name format and extension
    def validate_file_name!
      unless @file_name.length.between?(FILENAME_MIN_LENGTH, FILENAME_MAX_LENGTH)
        raise ArgumentError, "file_name must be #{FILENAME_MIN_LENGTH} to #{FILENAME_MAX_LENGTH} characters"
      end

      extension = File.extname(@file_name.downcase)
      unless VALID_EXTENSIONS.include?(extension)
        raise ArgumentError, "Unsupported file extension: #{extension}. Supported: #{VALID_EXTENSIONS.join(', ')}"
      end
    end

    # Validate the image size (basic check)
    def validate_file_size!
      max_bytes = 32 * 1024 * 1024
      size = if @image.nil?
               # base64 is about 4/3 of the decoded size
               @base64.length * 3 / 4
             elsif @image.is_a?(String)
               @image.bytesize
             elsif @image.respond_to?(:size)
               @image.size
             end
      raise ArgumentError, 'Image size exceeds maximum limit of 32MB' if size && size >= max_bytes
    end
  end
end
