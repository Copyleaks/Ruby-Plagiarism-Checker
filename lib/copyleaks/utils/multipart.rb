require 'securerandom'

module Copyleaks
  # Builds a multipart/form-data body in memory. Files go as raw bytes, without base64 overhead.
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

    # data is a binary String or an IO. An IO is rewound first when possible, so the request can be resent.
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
