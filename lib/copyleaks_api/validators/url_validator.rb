module CopyleaksApi
  module Validators
    class UrlValidator
      class << self
        # raises error if given url for callback is invalid
        def validate!(url)
          raise BadUrlError.new(url) unless url =~ %r(^(https?://)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w \.-]*)*/?$)
        end
      end
    end
  end
end
