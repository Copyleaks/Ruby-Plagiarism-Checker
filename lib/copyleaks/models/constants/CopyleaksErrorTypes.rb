module Copyleaks
  # Documented values of error.type in an API error response (CopyleaksApiException#error_type).
  # See https://docs.copyleaks.com/using-the-apis/api-errors/
  class CopyleaksErrorTypes
    # Invalid request format, missing parameters or malformed data.
    INVALID_REQUEST_ERROR = "invalid_request_error"
    # Invalid credentials, a disabled account or too many failed login attempts.
    AUTHENTICATION_ERROR = "authentication_error"
    # Insufficient credits, an expired subscription or a team billing error.
    PAYMENT_ERROR = "payment_error"
    # Internal server error, overload, timeout or temporary unavailability.
    API_ERROR = "api_error"
  end
end
