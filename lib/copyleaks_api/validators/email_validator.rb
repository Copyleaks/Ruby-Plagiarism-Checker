module CopyleaksApi
  module Validators
    class EmailValidator
      class << self
        def validate!(email)
          return if email =~ /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
          raise BadEmailError.new(email), "Email #{email} is invalid"
        end
      end
    end
  end
end
