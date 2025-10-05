# frozen_string_literal: true

module Copyleaks

        # Request model for Copyleaks AI image detection.
        # The request body is a JSON object containing the image to analyze.
        class CopyleaksAiImageDetectionRequestModel
          attr_accessor :base64, :file_name, :model, :sandbox

          # Initialize a new CopyleaksAiImageDetectionRequestModel
          #
          # @param base64 [String] The base64-encoded image data to be analyzed for AI generation
          # @param file_name [String] The name of the image file including its extension
          # @param model [String] The AI detection model to use for analysis
          # @param sandbox [Boolean] Use sandbox mode to test integration (default: false)
          def initialize(base64, file_name, model, sandbox = false)
            @base64 = base64
            @file_name = file_name
            @model = model
            @sandbox = sandbox
          end

          # The base64-encoded image data to be analyzed for AI generation.
          #
          # Requirements:
          # - Minimum 512×512px, maximum 16 megapixels, less than 32MB
          # - Supported formats: PNG, JPEG, BMP, WebP, HEIC/HEIF
          #
          # @example "aGVsbG8gd29ybGQ="
          # @return [String] Base64-encoded image data
          attr_reader :base64

          # The name of the image file including its extension.
          #
          # Requirements:
          # - Supported extensions: .png, .bmp, .jpg, .jpeg, .webp, .heic, .heif
          # - Maximum 255 characters
          #
          # @example "my-image.png"
          # @return [String] Image file name
          attr_reader :file_name

          # The AI detection model to use for analysis.
          # You can use either the full model name or its alias.
          #
          # Available models:
          # - AI Image 1 Ultra: "ai-image-1-ultra-01-09-2025" (full name) or "ai-image-1-ultra" (alias)
          #   AI image detection model. Produces an overlay of the detected AI segments.
          #
          # @example "ai-image-1-ultra-01-09-2025" or "ai-image-1-ultra"
          # @return [String] Model name or alias
          attr_reader :model

          # Use sandbox mode to test your integration with the Copyleaks API without consuming any credits.
          #
          # Submit images for AI detection and get returned mock results, simulating Copyleaks' API functionality
          # to ensure you have successfully integrated the API.
          # This feature is intended to be used for development purposes only.
          # Default value is false.
          #
          # @example false
          # @return [Boolean] Sandbox mode flag
          attr_reader :sandbox

          # Convert the model to a hash for JSON serialization
          #
          # @return [Hash] Hash representation of the model
          def to_hash
            {
              base64: @base64,
              fileName: @file_name,
              model: @model,
              sandbox: @sandbox
            }
          end

          # Convert the model to JSON
          #
          # @return [String] JSON representation of the model
          def to_json(*args)
            to_hash.to_json(*args)
          end

          # Validate the model data
          #
          # @raise [ArgumentError] If required fields are missing or invalid
          def validate!
            raise ArgumentError, 'base64 is required' if @base64.nil? || @base64.empty?
            raise ArgumentError, 'file_name is required' if @file_name.nil? || @file_name.empty?
            raise ArgumentError, 'model is required' if @model.nil? || @model.empty?
            
            validate_file_name!
            validate_file_size!
          end

          private

          # Validate file name format and extension
          def validate_file_name!
            raise ArgumentError, 'file_name exceeds maximum length of 255 characters' if @file_name.length > 255
            
            valid_extensions = %w[.png .bmp .jpg .jpeg .webp .heic .heif]
            extension = File.extname(@file_name.downcase)
            
            unless valid_extensions.include?(extension)
              raise ArgumentError, "Unsupported file extension: #{extension}. Supported: #{valid_extensions.join(', ')}"
            end
          end

          # Validate base64 data size (basic check)
          def validate_file_size!
            # Basic size check - base64 data should not exceed ~42MB (32MB * 4/3 base64 overhead)
            max_base64_size = 44_000_000 # Approximately 32MB when decoded
            
            if @base64.length > max_base64_size
              raise ArgumentError, 'Image size exceeds maximum limit of 32MB'
            end
          end
        end
end
