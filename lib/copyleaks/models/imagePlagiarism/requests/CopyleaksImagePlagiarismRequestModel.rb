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
  # Request model for the Image Plagiarism Detector. The image is uploaded as multipart/form-data.
  class CopyleaksImagePlagiarismRequestModel
    FILENAME_MAX_LENGTH = 255

    attr_reader :image, :filename, :sandbox, :developer_payload

    # @param image [String, IO] The raw image bytes, for example File.binread(path), or an IO to read them from.
    #   Less than 20MB, at most 75 megapixels. Formats: JPG, JPEG, PNG, GIF, BMP, WebP, ICO.
    # @param filename [String] The name of the image file including its extension (at most 255 characters).
    # @param sandbox [Boolean, nil] Use sandbox mode: free, returns mock results. Server default: false.
    # @param developer_payload [String, nil] A string that is echoed back in the response.
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

    # Build the multipart/form-data body: image (file), filename, sandbox and developerPayload.
    # @return [Copyleaks::MultipartForm]
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
