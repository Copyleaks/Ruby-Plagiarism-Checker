module Copyleaks
    class SubmissionLanguage
      # @param [String] code See API#get_allowed_cross_languages.
      def initialize(code)
        @code = code
      end
  
      def as_json(*_args)
        {
            code: @code,
        }.select { |_k, v| !v.nil? }
      end
  
      def to_json(*options)
        as_json(*options).to_json(*options)
      end
    end
  end
