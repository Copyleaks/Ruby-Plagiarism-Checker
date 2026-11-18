# frozen_string_literal: true

require_relative 'test_helper'

# The error envelope readers of Copyleaks::CopyleaksApiException, with responses from the local stub server.
class ApiErrorsTest < Minitest::Test
  include CopyleaksTestHelpers

  FULL_ENVELOPE = {
    error: {
      type: 'invalid_request_error',
      id: 'missing_parameter',
      code: 1,
      message: 'Bad request. One or several required parameters are missing or incorrect.',
      url: 'https://docs.copyleaks.com/using-the-apis/api-errors/#error-reference',
      details: [
        { param: 'labels', message: 'Id Label EXAMPLE-v1 is not supported' },
        { param: 'filename', message: 'Invalid extension' }
      ]
    }
  }.to_json

  def error_for(status, body, headers = {})
    @server.respond { |_req| [status, headers, body] }
    assert_raises(Copyleaks::CopyleaksApiException) { api.get_credits_balance(token) }
  end

  def assert_no_envelope(error)
    assert_nil error.error_type
    assert_nil error.error_id
    assert_nil error.error_code
    assert_nil error.error_message
    assert_nil error.error_url
    assert_equal [], error.error_details
  end

  def test_full_envelope
    error = error_for(400, FULL_ENVELOPE)
    assert_instance_of Copyleaks::CommandException, error
    assert_equal Copyleaks::CopyleaksErrorTypes::INVALID_REQUEST_ERROR, error.error_type
    assert_equal 'missing_parameter', error.error_id
    assert_equal 1, error.error_code
    assert_equal 'Bad request. One or several required parameters are missing or incorrect.', error.error_message
    assert_equal 'https://docs.copyleaks.com/using-the-apis/api-errors/#error-reference', error.error_url

    details = error.error_details
    assert_equal 2, details.size
    assert_instance_of Copyleaks::CopyleaksApiErrorDetail, details.first
    assert_equal 'labels', details.first.param
    assert_equal 'Id Label EXAMPLE-v1 is not supported', details.first.message
    assert_equal 'filename', details.last.param
    assert_equal 'Invalid extension', details.last.message

    # Existing behaviour is unchanged.
    assert_equal '400', error.response.code
    assert_includes error.message, 'missing_parameter'
  end

  def test_rate_limit_and_maintenance_exceptions_read_the_envelope_too
    body = { error: { type: 'api_error', id: 'too_many_requests', code: 7 } }.to_json
    error = error_for(429, body, 'Retry-After' => '30')
    assert_instance_of Copyleaks::RateLimitException, error
    assert_equal 'Too many requests. Please wait before calling again.', error.message
    assert_equal '30', error.retry_after
    assert_equal Copyleaks::CopyleaksErrorTypes::API_ERROR, error.error_type
    assert_equal 'too_many_requests', error.error_id
    assert_equal 7, error.error_code

    error = error_for(503, '')
    assert_instance_of Copyleaks::UnderMaintenanceException, error
    assert_no_envelope(error)
  end

  def test_missing_optional_fields
    error = error_for(401, '{"error":{"type":"authentication_error","code":2}}')
    assert_equal Copyleaks::CopyleaksErrorTypes::AUTHENTICATION_ERROR, error.error_type
    assert_equal 2, error.error_code
    assert_nil error.error_id
    assert_nil error.error_message
    assert_nil error.error_url
    assert_equal [], error.error_details

    assert_no_envelope(error_for(400, '{"error":{}}'))
  end

  def test_unknown_type_is_returned_as_is
    error = error_for(402, '{"error":{"type":"future_error","id":"x"}}')
    assert_equal 'future_error', error.error_type
  end

  def test_code_as_numeric_string
    assert_equal 12, error_for(400, '{"error":{"code":"12"}}').error_code
    assert_equal 3, error_for(400, '{"error":{"code":" 3 "}}').error_code
    assert_equal(-4, error_for(400, '{"error":{"code":"-4"}}').error_code)
  end

  def test_code_of_another_type_is_absent
    ['"abc"', '"1.5"', '"1_000"', '""', '1.0', 'true', 'null', '[1]', '{"v":1}'].each do |code|
      assert_nil error_for(400, "{\"error\":{\"code\":#{code}}}").error_code, "code #{code}"
    end
    # A String that is not valid UTF-8 (sent with 429, see test_non_json_body).
    assert_nil error_for(429, "{\"error\":{\"code\":\"1\xFF\"}}".b).error_code
  end

  def test_fields_of_the_wrong_type_are_absent
    error = error_for(400, '{"error":{"type":1,"id":["a"],"message":{"m":1},"url":false}}')
    assert_no_envelope(error)
  end

  def test_non_json_body
    ['<html><body>Bad Gateway</body></html>', 'not json', '{"error":'].each do |body|
      error = error_for(400, body)
      assert_instance_of Copyleaks::CommandException, error
      assert_no_envelope(error)
    end
    # Bytes that are not UTF-8. Sent with 429: CommandException cannot be built from a non-ASCII body (existing issue).
    assert_no_envelope(error_for(429, "\xFF\xFE{".b))
  end

  def test_non_ascii_text_is_read_as_utf8
    body = { error: { message: 'Ungültige Anfrage', details: [{ param: 'filename', message: 'Ungültig' }] } }.to_json
    error = error_for(429, body)
    encoding = error.response.body.encoding
    assert_equal 'Ungültige Anfrage', error.error_message
    assert_equal Encoding::UTF_8, error.error_message.encoding
    assert_equal 'Ungültig', error.error_details.first.message
    # The readers parse a copy: response.body keeps its encoding (binary here, as Net::HTTP returns it).
    assert_equal Encoding::ASCII_8BIT, encoding
    assert_equal encoding, error.response.body.encoding
  end

  def test_json_without_an_error_object
    ['{}', '{"error":"conflict"}', '{"error":null}', '{"error":[1]}', '{"type":"api_error"}', '[]', '"text"', '7',
     'null'].each do |body|
      assert_no_envelope(error_for(400, body))
    end
  end

  def test_malformed_details
    ['"labels"', '{"param":"labels"}', 'null', '7'].each do |details|
      assert_equal [], error_for(400, "{\"error\":{\"details\":#{details}}}").error_details, "details #{details}"
    end

    body = '{"error":{"code":1,"details":["labels",null,7,[],{"param":1,"message":"m"},{"param":"p"},{}]}}'
    details = error_for(400, body).error_details
    assert_equal 3, details.size
    assert_nil details[0].param
    assert_equal 'm', details[0].message
    assert_equal 'p', details[1].param
    assert_nil details[1].message
    assert_nil details[2].param
    assert_nil details[2].message
  end

  def test_exceptions_without_a_response
    [Copyleaks::RateLimitException.new, Copyleaks::UnderMaintenanceException.new,
     Copyleaks::CopyleaksApiException.new('failed')].each do |error|
      assert_nil error.response
      assert_no_envelope(error)
    end
  end

  def test_streamed_usage_history_errors_read_the_envelope
    @server.respond { |_req| [400, {}, FULL_ENVELOPE] }
    error = assert_raises(Copyleaks::CommandException) do
      api.get_usages_history_csv(token, '01-01-2026', '02-01-2026') { |_chunk| flunk 'no chunk expected' }
    end
    assert_equal 'missing_parameter', error.error_id
    assert_equal 1, error.error_code
  end

  def test_readers_are_stable_and_work_on_a_frozen_exception
    error = error_for(400, FULL_ENVELOPE)
    assert_equal error.error_id, error.error_id
    error.error_details.clear
    assert_equal 2, error.error_details.size

    frozen = error_for(400, FULL_ENVELOPE).freeze
    assert_equal 'missing_parameter', frozen.error_id
    assert_equal 2, frozen.error_details.size
  end

  def test_error_type_constants
    assert_equal 'invalid_request_error', Copyleaks::CopyleaksErrorTypes::INVALID_REQUEST_ERROR
    assert_equal 'authentication_error', Copyleaks::CopyleaksErrorTypes::AUTHENTICATION_ERROR
    assert_equal 'payment_error', Copyleaks::CopyleaksErrorTypes::PAYMENT_ERROR
    assert_equal 'api_error', Copyleaks::CopyleaksErrorTypes::API_ERROR
  end
end
