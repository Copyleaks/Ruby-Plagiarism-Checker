module CopyleaksApi
  module Validators
    class LanguageValidator
      class << self
        def validate!(language)
          raise UnknownLanguageError, "#{language} is unknown" unless Language::ALLOWED.include?(language)
        end
      end
    end
  end
end
