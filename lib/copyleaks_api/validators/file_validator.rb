module CopyleaksApi
  module Validators
    class FileValidator
      SUPPORTED_FILE_TYPES = [:html, :htm, :txt, :pdf, :doc, :docx, :rtf].freeze
      SUPPORTED_IMAGE_TYPES = [:gif, :png, :bmp, :jpg, :jpeg].freeze
      BYTES_IN_MB = 1_024_000.0

      class << self
        # check file for ocr for correctness
        def validate_ocr!(path)
          validate_file(path, SUPPORTED_IMAGE_TYPES)
        end

        # check text file for correctness
        def validate_text_file!(path)
          validate_file(path, SUPPORTED_FILE_TYPES)
        end

        private

        # check given file for correctness to given type
        def validate_file(path, types)
          ext = file_extension(path)
          return if types.include?(ext) && file_size(path) <= allowed_file_size(ext)
          raise BadFileError, "#{path} file has unsupported extension or to large"
        end

        # returns good file size in MB for given type
        def allowed_file_size(type)
          case type.to_sym
          when :html, :htm
            5
          when :txt
            3
          when :pdf, :doc, :docx
            25
          when *SUPPORTED_IMAGE_TYPES
            25
          else
            0
          end
        end

        # extract file extension
        def file_extension(path)
          path.split('.').last.downcase.to_sym
        end

        # extract file size in MB
        def file_size(path)
          File.size(path) / BYTES_IN_MB
        end
      end
    end
  end
end
