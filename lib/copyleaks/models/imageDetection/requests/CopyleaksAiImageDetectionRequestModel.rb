module Copyleaks
  # Synchronous AI image detection request. Pass the image as base64 (JSON body), or pass nil and the raw
  # bytes as image:, e.g. image: File.binread(path) (multipart body, recommended: no base64 overhead).
  class CopyleaksAiImageDetectionRequestModel
    VALID_EXTENSIONS = %w[.png .bmp .jpg .jpeg .webp .heic .heif .avif].freeze
    FILENAME_MIN_LENGTH = 5
    FILENAME_MAX_LENGTH = 254
    MAX_OBJECT_DETECTION_ENTRIES = 3
    MAX_OBJECT_NAME_LENGTH = 32

    attr_accessor :base64, :file_name, :model, :sandbox, :mask_type, :object_detection, :image

    # @param file_name [String] With extension; see VALID_EXTENSIONS.
    # @param model [String] See CopyleaksAiImageDetectionModels.
    # @param sandbox [Boolean, nil] Test without using credits. nil omits the field (server default: false).
    # @param mask_type [String, nil] See CopyleaksAiImageMaskTypes. Server default: BINARY.
    # @param object_detection [Array<String>, nil] Up to 3 names, 1-32 chars each, e.g. ['face']. Adds detectedObjects.
    # @param image [String, IO, nil] Raw image bytes or an IO, uploaded as multipart/form-data.
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

    # True when image: is set, so the request is sent as multipart/form-data.
    def multipart?
      !@image.nil?
    end

    # Nil fields are left out.
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

    def to_json(*args)
      to_hash.to_json(*args)
    end

    # @return [Copyleaks::MultipartForm] The body used when image: is set.
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

    # Optional client-side checks; the client never calls this, so the server has the final say.
    # Limits: 512x512 to 6000x4500 px (27 MP), under 32 MB; PNG, JPEG, BMP, WebP, HEIC/HEIF, AVIF;
    # file name 5 to 254 characters with a supported extension.
    # @raise [ArgumentError] When a field is missing or invalid.
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

    def validate_file_name!
      unless @file_name.length.between?(FILENAME_MIN_LENGTH, FILENAME_MAX_LENGTH)
        raise ArgumentError, "file_name must be #{FILENAME_MIN_LENGTH} to #{FILENAME_MAX_LENGTH} characters"
      end

      extension = File.extname(@file_name.downcase)
      unless VALID_EXTENSIONS.include?(extension)
        raise ArgumentError, "Unsupported file extension: #{extension}. Supported: #{VALID_EXTENSIONS.join(', ')}"
      end
    end

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
