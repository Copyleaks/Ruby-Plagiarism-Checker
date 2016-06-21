module CopyleaksApi
  module Validators
    class UrlValidator
      class << self
        def validate!(url)
          raise BadUrlError.new(url) unless url =~ %r(^(https?://)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w \.-]*)*/?$)
        end
      end
    end
  end
end
