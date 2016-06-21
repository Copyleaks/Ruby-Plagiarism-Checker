module CopyleaksApi
  module Validators
    class CustomFieldsValidator
      KEY_MAX_LENGTH = 128
      VALUE_MAX_LENGTH = 512
      OVERALL_MAX_LENGTH = 8192

      class << self
        # raises appropriate error if any length is too large
        def validate!(fields)
          raise BadCustomFieldError.new('Key is too long') unless keys_valid?(fields)
          raise BadCustomFieldError.new('Value is too long') unless values_valid?(fields)
          raise BadCustomFieldError.new('Overall size is too large') unless overall_valid?(fields)
        end

        private

        # checks custom keys for length
        def keys_valid?(hash)
          hash.keys.map(&:to_s).all? { |s| s.size <= KEY_MAX_LENGTH }
        end

        # checks values for length
        def values_valid?(hash)
          hash.values.map(&:to_s).all? { |s| s.size <= VALUE_MAX_LENGTH }
        end

        # checks overall length
        def overall_valid?(hash)
          hash.reduce(0) { |a, e| a + e[0].to_s.size + e[1].to_s.size } <= OVERALL_MAX_LENGTH
        end
      end
    end
  end
end
