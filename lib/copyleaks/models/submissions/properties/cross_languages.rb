module Copyleaks
    class SubmissionCrossLanguages
      # @param [Language[]] languages - Languages to scan your content against.
      def initialize(languages = nil)
        if !languages.nil? && !(languages.is_a?(Array) && languages.all? { |element| element.is_a?(SubmissionLanguage) })
            raise 'Copyleaks::SubmissionCrossLanguages - languages - languages must be of type SubmissionLanguage[]'
        end
        @languages = languages
      end
  
      def as_json(*_args)
        {
            languages: @languages,
        }.select { |_k, v| !v.nil? }
      end
  
      def to_json(*options)
        as_json(*options).to_json(*options)
      end
    end
  end
