module Copyleaks
  # Request model for the Image Plagiarism Detector. The image is uploaded as multipart/form-data.
  class CopyleaksImagePlagiarismRequestModel
    FILENAME_MAX_LENGTH = 255

    attr_reader :image, :filename, :sandbox, :developer_payload

    # @param image [String, IO] Raw bytes, e.g. File.binread(path), or an IO. Under 20 MB, at most 75 megapixels;
    #   JPG, JPEG, PNG, GIF, BMP, WebP or ICO.
    # @param filename [String] With extension, at most 255 characters.
    # @param sandbox [Boolean, nil] Free mock results. Server default: false.
    # @param developer_payload [String, nil] Echoed back in the response.
    def initialize(image:, filename:, sandbox: nil, developer_payload: nil)
      unless image.is_a?(String) || image.respond_to?(:read)
        raise ArgumentError, 'Copyleaks::CopyleaksImagePlagiarismRequestModel - image must be a binary String or an IO'
      end
      unless filename.is_a?(String) && !filename.empty?
        raise ArgumentError, 'Copyleaks::CopyleaksImagePlagiarismRequestModel - filename must be a non-empty String'
      end
      if filename.length > FILENAME_MAX_LENGTH
        raise ArgumentError, "Copyleaks::CopyleaksImagePlagiarismRequestModel - filename must be at most #{FILENAME_MAX_LENGTH} characters"
      end
      if !sandbox.nil? && ![true, false].include?(sandbox)
        raise ArgumentError, 'Copyleaks::CopyleaksImagePlagiarismRequestModel - sandbox must be a Boolean'
      end
      if !developer_payload.nil? && !developer_payload.is_a?(String)
        raise ArgumentError, 'Copyleaks::CopyleaksImagePlagiarismRequestModel - developer_payload must be a String'
      end

      @image = image
      @filename = filename
      @sandbox = sandbox
      @developer_payload = developer_payload
    end

    # @return [Copyleaks::MultipartForm] Fields: image (file), filename, sandbox, developerPayload.
    def to_multipart
      form = MultipartForm.new
      form.add_file('image', @image, @filename)
      form.add_field('filename', @filename)
      form.add_field('sandbox', @sandbox) unless @sandbox.nil?
      form.add_field('developerPayload', @developer_payload) unless @developer_payload.nil?
      form
    end
  end
end
