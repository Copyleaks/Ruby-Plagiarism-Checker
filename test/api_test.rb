# frozen_string_literal: true

require_relative 'test_helper'

# Wire-level checks for the endpoints that existed before 5.0: method, path, headers and body.
class ApiTest < Minitest::Test
  include CopyleaksTestHelpers

  def test_login_posts_email_and_key_as_json
    @server.respond do |_req|
      [200, {}, { 'access_token' => 'abc', '.issued' => '2026-01-01T00:00:00Z', '.expires' => '2099-01-01T00:00:00Z' }.to_json]
    end
    result = api.login('user@example.com', 'secret-key')

    req = @server.last_request
    assert_equal 'POST', req.method
    assert_equal '/v3/account/login/api', req.path
    assert_json_headers(req, authorized: false)
    assert_equal({ 'email' => 'user@example.com', 'key' => 'secret-key' }, json_body(req))
    assert_equal 'abc', result.accessToken
    assert_equal '2099-01-01T00:00:00Z', result.expires
  end

  def test_login_validates_the_key
    error = assert_raises(RuntimeError) { api.login('user@example.com', nil) }
    assert_match(/key is Invalid/, error.message)
    assert_raises(RuntimeError) { api.login('user@example.com', 42) }
    assert_empty @server.requests
  end

  def test_submit_file
    submission = Copyleaks::CopyleaksFileSubmissionModel.new('aGVsbG8=', 'a.txt', properties)
    api.submit_file(token, 'scan1', submission)

    req = @server.last_request
    assert_equal 'PUT', req.method
    assert_equal '/v3/scans/submit/file/scan1', req.path
    assert_json_headers(req)
    assert_equal({ 'base64' => 'aGVsbG8=', 'filename' => 'a.txt',
                   'properties' => { 'webhooks' => { 'status' => WEBHOOK }, 'sandbox' => true } }, json_body(req))
  end

  def test_submit_file_ocr
    submission = Copyleaks::CopyleaksFileOcrSubmissionModel.new('en', 'aGVsbG8=', 'a.png', properties)
    api.submit_file_ocr(token, 'scan1', submission)

    req = @server.last_request
    assert_equal 'PUT', req.method
    assert_equal '/v3/scans/submit/ocr/scan1', req.path
    assert_json_headers(req)
    assert_equal 'en', json_body(req)['langCode']
    assert_equal 'a.png', json_body(req)['filename']
  end

  def test_submit_url_with_verb_and_headers
    submission = Copyleaks::CopyleaksURLSubmissionModel.new('https://example.com/page', properties,
                                                            verb: 'POST', headers: [%w[Cookie session=1]])
    api.submit_url(token, 'scan1', submission)

    req = @server.last_request
    assert_equal 'PUT', req.method
    assert_equal '/v3/scans/submit/url/scan1', req.path
    assert_json_headers(req)
    assert_equal({ 'url' => 'https://example.com/page', 'verb' => 'POST', 'headers' => [%w[Cookie session=1]],
                   'properties' => { 'webhooks' => { 'status' => WEBHOOK }, 'sandbox' => true } }, json_body(req))
  end

  def test_submit_url_without_options_sends_only_url_and_properties
    api.submit_url(token, 'scan1', Copyleaks::CopyleaksURLSubmissionModel.new('https://example.com', properties))
    assert_equal %w[properties url], json_body(@server.last_request).keys.sort
  end

  def test_scan_ids_are_percent_encoded_in_the_path
    submission = Copyleaks::CopyleaksFileSubmissionModel.new('aGVsbG8=', 'a.txt', properties)
    api.submit_file(token, 'a b/c?d#e%f', submission)
    assert_equal '/v3/scans/submit/file/a%20b%2Fc%3Fd%23e%25f', @server.last_request.path

    api.export(token, 'x/y', 'e 1', Copyleaks::CopyleaksExportModel.new(WEBHOOK, nil, nil,
                                                                        Copyleaks::ExportPdfReport.new('https://example.com/p', 'POST')))
    assert_equal '/v3/downloads/x%2Fy/export/e%201', @server.last_request.path

    api.resend_webhook(token, 'r#1')
    assert_equal '/v3/scans/r%231/webhooks/resend', @server.last_request.path
  end

  def test_export_with_all_targets
    model = Copyleaks::CopyleaksExportModel.new(
      WEBHOOK,
      [Copyleaks::ExportResults.new('r1', 'https://example.com/r1', 'POST', [%w[K V]])],
      Copyleaks::ExportCrawledVersion.new('https://example.com/c', 'POST'),
      Copyleaks::ExportPdfReport.new('https://example.com/p', 'PUT'),
      3,
      'payload',
      [%w[H1 V1]],
      aiDetection: Copyleaks::ExportAiDetection.new('https://example.com/ai', 'POST'),
      writingFeedback: Copyleaks::ExportWritingFeedback.new('https://example.com/wf', 'POST', [%w[A B]]),
      overview: Copyleaks::ExportOverview.new('https://example.com/ov', 'POST')
    )
    api.export(token, 'scan1', 'exp1', model)

    req = @server.last_request
    assert_equal 'POST', req.method
    assert_equal '/v3/downloads/scan1/export/exp1', req.path
    assert_json_headers(req)
    assert_equal({
                   'completionWebhook' => WEBHOOK,
                   'completionWebhookHeaders' => [%w[H1 V1]],
                   'results' => [{ 'id' => 'r1', 'endpoint' => 'https://example.com/r1', 'verb' => 'POST', 'headers' => [%w[K V]] }],
                   'crawledVersion' => { 'endpoint' => 'https://example.com/c', 'verb' => 'POST' },
                   'pdfReport' => { 'endpoint' => 'https://example.com/p', 'verb' => 'PUT' },
                   'aiDetection' => { 'endpoint' => 'https://example.com/ai', 'verb' => 'POST' },
                   'writingFeedback' => { 'endpoint' => 'https://example.com/wf', 'verb' => 'POST', 'headers' => [%w[A B]] },
                   'overview' => { 'endpoint' => 'https://example.com/ov', 'verb' => 'POST' },
                   'maxRetries' => 3,
                   'developerPayload' => 'payload'
                 }, json_body(req))
  end

  def test_export_no_longer_requires_results_or_crawled_version
    model = Copyleaks::CopyleaksExportModel.new(WEBHOOK, nil, nil, Copyleaks::ExportPdfReport.new('https://example.com/p', 'POST'))
    assert_equal({ 'completionWebhook' => WEBHOOK, 'pdfReport' => { 'endpoint' => 'https://example.com/p', 'verb' => 'POST' } },
                 json_of(model))
    only_ai = Copyleaks::CopyleaksExportModel.new(WEBHOOK, aiDetection: Copyleaks::ExportAiDetection.new('https://example.com/a', 'POST'))
    assert_equal %w[aiDetection completionWebhook], json_of(only_ai).keys.sort
    assert_raises(RuntimeError) { Copyleaks::CopyleaksExportModel.new(WEBHOOK, ['not-a-result']) }
    assert_raises(RuntimeError) { Copyleaks::CopyleaksExportModel.new(WEBHOOK, overview: Copyleaks::ExportPdfReport.new('u', 'POST')) }
    assert_raises(RuntimeError) { Copyleaks::ExportOverview.new('https://example.com', 'POST', 'bad-headers') }
  end

  def test_start
    api.start(token, Copyleaks::CopyleaksStartRequestModel.new(%w[s1 s2], Copyleaks::CopyleaksStartErrorHandlings::CANCEL))

    req = @server.last_request
    assert_equal 'PATCH', req.method
    assert_equal '/v3/scans/start', req.path
    assert_json_headers(req)
    assert_equal({ 'trigger' => %w[s1 s2], 'errorHandling' => 0 }, json_body(req))
  end

  def test_delete_with_headers
    model = Copyleaks::CopyleaksDeleteRequestModel.new([Copyleaks::IdObject.new('s1')], true, 'https://example.com/deleted',
                                                       headers: [%w[Authorization token]])
    api.delete(token, model)

    req = @server.last_request
    assert_equal 'PATCH', req.method
    assert_equal '/v3.1/scans/delete', req.path
    assert_json_headers(req)
    assert_equal({ 'scans' => [{ 'id' => 's1' }], 'purge' => true, 'completionWebhook' => 'https://example.com/deleted',
                   'headers' => [%w[Authorization token]] }, json_body(req))
  end

  def test_delete_defaults_send_only_the_scans
    assert_equal({ 'scans' => [{ 'id' => 's1' }] }, json_of(Copyleaks::CopyleaksDeleteRequestModel.new([Copyleaks::IdObject.new('s1')])))
    legacy = Copyleaks::CopyleaksDeleteRequestModel.new([Copyleaks::IdObject.new('s1')], false, '')
    assert_equal({ 'scans' => [{ 'id' => 's1' }], 'purge' => false }, json_of(legacy))
  end

  def test_resend_webhook_posts_an_empty_body
    api.resend_webhook(token, 'scan1')

    req = @server.last_request
    assert_equal 'POST', req.method
    assert_equal '/v3/scans/scan1/webhooks/resend', req.path
    assert_json_headers(req)
    assert_equal '0', req.headers['content-length']
    assert_equal '', req.body
  end

  def test_credits_balance
    @server.respond { |_req| [200, {}, '{"Amount":10}'] }
    assert_equal({ 'Amount' => 10 }, api.get_credits_balance(token))

    req = @server.last_request
    assert_equal 'GET', req.method
    assert_equal '/v3/scans/credits', req.path
    assert_json_headers(req)
  end

  def test_usage_history_returns_csv_text_with_encoded_query
    @server.respond { |_req| [200, { 'Content-Type' => 'text/csv' }, "date,credits\n01-01-2026,5\n"] }
    csv = api.get_usages_history_csv(token, '01-01-2026', '31-01-2026')

    assert_equal "date,credits\n01-01-2026,5\n", csv
    assert_equal Encoding::UTF_8, csv.encoding
    req = @server.last_request
    assert_equal 'GET', req.method
    assert_equal '/v3/scans/usages/history?start=01-01-2026&end=31-01-2026', req.path
    assert_json_headers(req)

    api.get_usages_history_csv(token, '01 01&2026', '31-01-2026')
    assert_equal '/v3/scans/usages/history?start=01+01%262026&end=31-01-2026', @server.last_request.path
  end

  def test_usage_history_streams_to_a_block
    big = "date,credits\n" + ("01-01-2026,5\n" * 20_000)
    @server.respond { |_req| [200, { 'Content-Type' => 'text/csv' }, big] }
    chunks = []
    result = api.get_usages_history_csv(token, '01-01-2026', '31-01-2026') { |chunk| chunks << chunk }

    assert_nil result
    assert_operator chunks.size, :>, 1
    assert_equal big, chunks.join
  end

  def test_usage_history_errors_raise_with_or_without_a_block
    @server.respond { |_req| [400, {}, '{"error":"bad dates"}'] }
    assert_raises(Copyleaks::CommandException) { api.get_usages_history_csv(token, 'a', 'b') }
    assert_raises(Copyleaks::CommandException) { api.get_usages_history_csv(token, 'a', 'b') { |_c| flunk 'no chunk expected' } }
  end

  def test_public_lookups_send_no_authorization
    @server.respond { |_req| [200, {}, '[]'] }
    api.get_ocr_supported_languages
    assert_equal '/v3/miscellaneous/ocr-languages-list', @server.last_request.path
    assert_json_headers(@server.last_request, authorized: false)

    api.get_supported_file_types
    assert_equal '/v3/miscellaneous/supported-plagiarism-file-types', @server.last_request.path
    assert_json_headers(@server.last_request, authorized: false)

    api.get_release_notes
    assert_equal '/v3/release-logs.json', @server.last_request.path

    api.writing_assistant_client.get_correction_types('e n')
    assert_equal '/v1/writing-feedback/correction-types/e%20n', @server.last_request.path
    assert_equal 'GET', @server.last_request.method
  end

  def test_ai_text_detection_sends_explain_and_sensitivity_and_prints_nothing
    @server.respond { |_req| [200, {}, '{"summary":{"human":0.1,"ai":0.9}}'] }
    submission = Copyleaks::NaturalLanguageSubmissionModel.new('x' * 300, 'en', true, explain: true, sensitivity: 3)
    result = nil
    out, err = capture_io { result = api.ai_detection_client.submit_natural_language(token, 'scan 1', submission) }

    assert_equal '', out, 'the SDK must not write responses to stdout'
    assert_equal '', err
    assert_equal({ 'human' => 0.1, 'ai' => 0.9 }, result['summary'])
    req = @server.last_request
    assert_equal 'POST', req.method
    assert_equal '/v2/writer-detector/scan%201/check', req.path
    assert_json_headers(req)
    assert_equal({ 'text' => 'x' * 300, 'sandbox' => true, 'language' => 'en', 'explain' => true, 'sensitivity' => 3 }, json_body(req))
  end

  def test_ai_text_detection_defaults_send_only_the_text
    assert_equal({ 'text' => 'abc' }, json_of(Copyleaks::NaturalLanguageSubmissionModel.new('abc')))
    assert_raises(RuntimeError) { Copyleaks::NaturalLanguageSubmissionModel.new('abc', nil, nil, sensitivity: 4) }
    assert_raises(RuntimeError) { Copyleaks::NaturalLanguageSubmissionModel.new('abc', nil, nil, explain: 'yes') }
  end

  def test_writing_assistant
    submission = Copyleaks::WritingAssistantSubmissionModel.new('Some text', true, 'en', Copyleaks::ScoreWeights.new(0.1, 0.2, 0.3, 0.4))
    api.writing_assistant_client.submit_text(token, 'scan1', submission)

    req = @server.last_request
    assert_equal 'POST', req.method
    assert_equal '/v1/writing-feedback/scan1/check', req.path
    assert_json_headers(req)
    assert_equal({ 'text' => 'Some text', 'sandbox' => true, 'language' => 'en',
                   'score' => { 'grammarScoreWeight' => 0.1, 'mechanicsScoreWeight' => 0.2,
                                'sentenceStructureScoreWeight' => 0.3, 'wordChoiceScoreWeight' => 0.4 } }, json_body(req))
    assert_equal({ 'text' => 'abc' }, json_of(Copyleaks::WritingAssistantSubmissionModel.new('abc')))
  end

  def test_text_moderation
    labels = [Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::TOXIC_V1)]
    request = Copyleaks::CopyleaksTextModerationRequestModel.new(text: 'hello', sandbox: true, labels: labels)
    api.text_moderation_client.submit_text(token, 'scan1', request)

    req = @server.last_request
    assert_equal 'POST', req.method
    assert_equal '/v1/text-moderation/scan1/check', req.path
    assert_json_headers(req)
    assert_equal({ 'text' => 'hello', 'sandbox' => true, 'labels' => [{ 'id' => 'toxic-v1' }] }, json_body(req))
  end

  def test_text_moderation_labels_are_required_and_capped_at_16
    label = Copyleaks::CopyleaksTextModerationLabel.new('toxic-v1')
    assert_raises(ArgumentError) { Copyleaks::CopyleaksTextModerationRequestModel.new(text: 'x', labels: []) }
    assert_raises(ArgumentError) { Copyleaks::CopyleaksTextModerationRequestModel.new(text: 'x', labels: [label] * 17) }
    Copyleaks::CopyleaksTextModerationRequestModel.new(text: 'x', labels: [label] * 16)
  end

  def test_ai_image_check_as_json
    model = Copyleaks::CopyleaksAiImageDetectionRequestModel.new('aGVsbG8=', 'image.png', 'ai-image-1-ultra', true,
                                                                 mask_type: 'heatmap', object_detection: %w[face hand])
    api.ai_image_detection_client.submit_(token, 'scan1', model)

    req = @server.last_request
    assert_equal 'POST', req.method
    assert_equal '/v1/ai-image-detector/scan1/check', req.path
    assert_json_headers(req)
    assert_equal({ 'base64' => 'aGVsbG8=', 'filename' => 'image.png', 'model' => 'ai-image-1-ultra', 'sandbox' => true,
                   'maskType' => 'heatmap', 'objectDetection' => [{ 'object' => 'face' }, { 'object' => 'hand' }] }, json_body(req))
  end

  def test_ai_image_check_defaults_omit_unset_fields
    model = Copyleaks::CopyleaksAiImageDetectionRequestModel.new('aGVsbG8=', 'image.png', 'ai-image-1-ultra')
    assert_equal({ 'base64' => 'aGVsbG8=', 'filename' => 'image.png', 'model' => 'ai-image-1-ultra' }, json_of(model))
  end

  def test_ai_image_check_as_multipart
    model = Copyleaks::CopyleaksAiImageDetectionRequestModel.new(nil, 'image.png', 'ai-image-1-ultra', true,
                                                                 mask_type: 'none', object_detection: ['face'], image: png_bytes)
    api.ai_image_detection_client.check(token, 'scan1', model)

    req = @server.last_request
    assert_equal 'POST', req.method
    assert_equal '/v1/ai-image-detector/scan1/check', req.path
    assert_match %r{\Amultipart/form-data; boundary=}, req.headers['content-type']
    assert_equal 'Bearer test-access-token', req.headers['authorization']
    parts = multipart_parts(req)
    assert_equal %w[filename image maskType model objectDetection sandbox], parts.keys.sort
    assert_equal 'image.png', parts['image'][:filename]
    assert_equal 'image/png', parts['image'][:content_type]
    assert_equal png_bytes, parts['image'][:value]
    assert_equal 'image.png', parts['filename'][:value]
    assert_equal 'ai-image-1-ultra', parts['model'][:value]
    assert_equal 'true', parts['sandbox'][:value]
    assert_equal 'none', parts['maskType'][:value]
    assert_equal '[{"object":"face"}]', parts['objectDetection'][:value]
  end

  def test_ai_image_request_validation
    assert_raises(ArgumentError) { Copyleaks::CopyleaksAiImageDetectionRequestModel.new('b64', 'a.png', 'm', nil, image: 'bytes') }
    assert_raises(ArgumentError) { Copyleaks::CopyleaksAiImageDetectionRequestModel.new('b64', 'a.png', 'm', nil, object_detection: %w[a b c d]) }
    assert_raises(ArgumentError) { Copyleaks::CopyleaksAiImageDetectionRequestModel.new('b64', 'a.png', 'm', nil, object_detection: ['x' * 33]) }
    model = Copyleaks::CopyleaksAiImageDetectionRequestModel.new('b64', 'photo.avif', 'm')
    model.validate!
    assert_raises(ArgumentError) { Copyleaks::CopyleaksAiImageDetectionRequestModel.new('b64', 'a.gif', 'm').validate! }
    assert_raises(ArgumentError) { Copyleaks::CopyleaksAiImageDetectionRequestModel.new('b64', 'a.pn', 'm').validate! }
  end

  def test_error_status_codes_map_to_exceptions
    @server.respond { |_req| [409, {}, '{"error":"conflict"}'] }
    error = assert_raises(Copyleaks::CommandException) { api.get_credits_balance(token) }
    assert_equal '409', error.response.code
    assert_includes error.message, 'conflict'

    @server.respond { |_req| [429, { 'Retry-After' => '30' }, ''] }
    error = assert_raises(Copyleaks::RateLimitException) { api.get_credits_balance(token) }
    assert_equal '30', error.retry_after
    assert_equal '429', error.response.code

    @server.respond { |_req| [503, { 'Retry-After' => '120' }, ''] }
    error = assert_raises(Copyleaks::UnderMaintenanceException) { api.get_credits_balance(token) }
    assert_equal '120', error.retry_after

    # The exceptions can still be built without a response, as before.
    assert_nil Copyleaks::RateLimitException.new.retry_after
    assert_nil Copyleaks::UnderMaintenanceException.new.response
  end

  def test_api_exceptions_share_a_base_class
    [Copyleaks::CommandException, Copyleaks::RateLimitException, Copyleaks::UnderMaintenanceException].each do |klass|
      assert_operator klass, :<, Copyleaks::CopyleaksApiException
      assert_operator klass, :<, RuntimeError
    end
    @server.respond { |_req| [429, { 'Retry-After' => '5' }, ''] }
    error = assert_raises(Copyleaks::CopyleaksApiException) { api.get_credits_balance(token) }
    assert_instance_of Copyleaks::RateLimitException, error
    assert_equal 'Too many requests. Please wait before calling again.', error.message

    @server.respond { |_req| [400, { 'Retry-After' => '1' }, '{}'] }
    error = assert_raises(RuntimeError) { api.get_credits_balance(token) }
    assert_instance_of Copyleaks::CommandException, error
    assert_equal '1', error.retry_after
  end

  def test_expired_tokens_are_rejected_before_any_request
    now = Time.now.utc
    expired = Copyleaks::CopyleaksAuthToken.new((now - 60).iso8601, 't', (now - 3600).iso8601)
    nearly = Copyleaks::CopyleaksAuthToken.new((now + 60).iso8601, 't', (now - 3600).iso8601)
    valid = Copyleaks::CopyleaksAuthToken.new((now + 3600).iso8601, 't', (now - 3600).iso8601)

    assert_raises(Copyleaks::AuthExpiredException) { api.get_credits_balance(expired) }
    assert_raises(Copyleaks::AuthExpiredException) { api.verify_auth_token(nearly) }
    assert_nil api.verify_auth_token(valid)
    assert_raises(RuntimeError) { api.verify_auth_token('not a token') }
    assert_empty @server.requests
  end

  def test_per_client_server_uris_do_not_change_the_global_config
    api.get_credits_balance(token)
    assert_equal 'https://api.copyleaks.com', Copyleaks::Config.api_server_uri
    assert_equal 'https://id.copyleaks.com', Copyleaks::Config.identity_server_uri
    assert_equal 1, @server.requests.size
  end
end
