module Copyleaks
    class SubmissionCustomMetadata
      def initialize(key, value)
        @key = key
        @value = value
      end
  
      def as_json(*_args)
        {
            key: @key,
            value: @value
        }.select { |_k, v| !v.nil? }
      end
  
      def to_json(*options)
        as_json(*options).to_json(*options)
      end
    end
  end
