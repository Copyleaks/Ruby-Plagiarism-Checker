module Copyleaks
  # One entry of error.details in an API error response: a parameter that caused the error.
  # See CopyleaksApiException#error_details.
  class CopyleaksApiErrorDetail
    # @return [String, nil] The request parameter, for example 'labels'.
    attr_reader :param
    # @return [String, nil] What is wrong with it.
    attr_reader :message

    def initialize(param: nil, message: nil)
      @param = param
      @message = message
    end
  end
end
