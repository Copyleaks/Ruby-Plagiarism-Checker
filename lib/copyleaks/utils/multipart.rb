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
require 'securerandom'

module Copyleaks
  # Builds a multipart/form-data request body in memory.
  # The file is sent as raw bytes, without the base64 overhead of the JSON endpoints.
  class MultipartForm
    CRLF = "\r\n".b.freeze

    IMAGE_CONTENT_TYPES = {
      '.png' => 'image/png',
      '.jpg' => 'image/jpeg',
      '.jpeg' => 'image/jpeg',
      '.gif' => 'image/gif',
      '.bmp' => 'image/bmp',
      '.webp' => 'image/webp',
      '.ico' => 'image/x-icon',
      '.heic' => 'image/heic',
      '.heif' => 'image/heif',
      '.tif' => 'image/tiff',
      '.tiff' => 'image/tiff',
      '.avif' => 'image/avif'
    }.freeze

    attr_reader :boundary

    def initialize(boundary = nil)
      @boundary = boundary || "copyleaks-#{SecureRandom.hex(16)}"
      @parts = []
    end

    # Adds a text field. Booleans are sent as "true" / "false".
    def add_field(name, value)
      @parts << [name.to_s, value.to_s, nil, nil]
      self
    end

    # Adds a file field. data is a binary String or an IO that responds to #read.
    # An IO is rewound first when it can be, so the same request can be sent again.
    def add_file(name, data, filename, content_type = nil)
      bytes = data.respond_to?(:read) ? read_io(data) : data
      raise ArgumentError, "Copyleaks::MultipartForm - #{name} - file data must be a String or an IO" unless bytes.is_a?(String)

      content_type ||= self.class.content_type_for(filename)
      @parts << [name.to_s, bytes, filename.to_s, content_type]
      self
    end

    def content_type
      "multipart/form-data; boundary=#{@boundary}"
    end

    def body
      out = String.new(encoding: Encoding::BINARY)
      @parts.each do |name, value, filename, content_type|
        out << "--#{@boundary}".b << CRLF
        disposition = "Content-Disposition: form-data; name=\"#{escape(name)}\""
        disposition += "; filename=\"#{escape(filename)}\"" if filename
        out << disposition.b << CRLF
        out << "Content-Type: #{content_type}".b << CRLF if content_type
        out << CRLF
        # File.binread already returns binary data, so only text values need a binary copy.
        out << (value.encoding == Encoding::BINARY ? value : value.b) << CRLF
      end
      out << "--#{@boundary}--".b << CRLF
      out
    end

    def self.content_type_for(filename)
      IMAGE_CONTENT_TYPES.fetch(File.extname(filename.to_s).downcase, 'application/octet-stream')
    end

    private

    def read_io(io)
      begin
        io.rewind if io.respond_to?(:rewind)
      rescue Errno::ESPIPE
        # Pipes and sockets cannot be rewound; they are read from where they are.
      end
      io.read
    end

    # Quotes and line breaks cannot appear inside a quoted header value.
    def escape(value)
      value.to_s.gsub('"', '%22').gsub("\r", '%0D').gsub("\n", '%0A')
    end
  end
end
