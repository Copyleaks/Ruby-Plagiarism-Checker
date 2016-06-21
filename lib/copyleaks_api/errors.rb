module CopyleaksApi
  BasicError = Class.new(StandardError)
  BadCustomFieldError = Class.new(BasicError)
  BadFileError = Class.new(BasicError)
  BadEmailError = Class.new(BasicError)
  BadUrlError = Class.new(BasicError)
  UnknownLanguageError = Class.new(BasicError)

  class BadResponseError < BasicError
    attr_accessor :code

    # constructor
    def initialize(code)
      @code = code.to_i
    end
  end

  class ManagedError < BadResponseError
    # returns true if this error is internal server error
    def internal_error?
      code == 16
    end
  end
end
