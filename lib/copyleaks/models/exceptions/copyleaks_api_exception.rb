require 'json'

module Copyleaks
  # An error response from the Copyleaks API. Rescue it to handle CommandException, RateLimitException and
  # UnderMaintenanceException together.
  #
  # The error_* readers return the fields of the error envelope in the response body
  # ({"error": {"type", "id", "code", "message", "url", "details"}}, see
  # https://docs.copyleaks.com/using-the-apis/api-errors/). Each one is nil (error_details: an empty Array)
  # when the field is missing or has the wrong type, or when the body is not such an envelope. They never raise.
  class CopyleaksApiException < RuntimeError
    # The HTTP response, or nil when the exception was raised without one.
    attr_reader :response

    def initialize(message, response = nil)
      @response = response
      super(message)
    end

    # The value of the Retry-After response header, or nil when the server did not send one.
    def retry_after
      @response.nil? ? nil : @response['Retry-After']
    end

    # @return [String, nil] For example CopyleaksErrorTypes::INVALID_REQUEST_ERROR. Unknown values are returned as is.
    def error_type
      error_string('type')
    end

    # @return [String, nil] Machine-readable, for example 'missing_parameter'.
    def error_id
      error_string('id')
    end

    # @return [Integer, nil] The error code. A numeric String in the body is converted to an Integer.
    def error_code
      code = error_envelope['code']
      return code if code.is_a?(Integer)
      return code.strip.to_i if code.is_a?(String) && code.valid_encoding? && code.match?(/\A\s*[+-]?\d+\s*\z/)

      nil
    end

    # @return [String, nil] The error message of the body. Exception#message is not changed.
    def error_message
      error_string('message')
    end

    # @return [String, nil] The documentation page for this error.
    def error_url
      error_string('url')
    end

    # @return [Array<CopyleaksApiErrorDetail>] The parameters that caused the error. Entries that are not
    #   objects are skipped. Empty when the body has no details.
    def error_details
      details = error_envelope['details']
      return [] unless details.is_a?(Array)

      details.select { |detail| detail.is_a?(Hash) }.map do |detail|
        CopyleaksApiErrorDetail.new(
          param: detail['param'].is_a?(String) ? detail['param'] : nil,
          message: detail['message'].is_a?(String) ? detail['message'] : nil
        )
      end
    end

    private

    def error_string(name)
      value = error_envelope[name]
      value.is_a?(String) ? value : nil
    end

    # The 'error' object of the response body, parsed once. An empty Hash when there is none.
    def error_envelope
      return @error_envelope if defined?(@error_envelope)

      envelope = parse_error_envelope
      @error_envelope = envelope unless frozen?
      envelope
    end

    def parse_error_envelope
      body = @response.respond_to?(:body) ? @response.body : nil
      return {} unless body.is_a?(String) && !body.empty?

      # Parse a copy: JSON.parse can re-tag a binary String as UTF-8 in place, which would change response.body.
      parsed = JSON.parse(body.dup)
      error = parsed.is_a?(Hash) ? parsed['error'] : nil
      error.is_a?(Hash) ? error : {}
    rescue StandardError
      {}
    end
  end
end
