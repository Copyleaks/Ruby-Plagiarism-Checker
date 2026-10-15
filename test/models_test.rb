# frozen_string_literal: true

require_relative 'test_helper'

# Serialization of the request models, and parsing of the response and webhook models.
class ModelsTest < Minitest::Test
  WEBHOOK = 'https://example.com/webhook/{STATUS}'

  def webhooks
    Copyleaks::SubmissionWebhooks.new(WEBHOOK)
  end

  def json_of(model)
    JSON.parse(model.to_json)
  end

  def test_only_webhooks_is_required
    assert_equal({ 'webhooks' => { 'status' => WEBHOOK } }, json_of(Copyleaks::SubmissionProperties.new(webhooks)))
  end

  def test_developer_payload_expiration_and_sensitivity_level_are_optional
    props = Copyleaks::SubmissionProperties.new(webhooks, true, nil, true, nil, nil)
    assert_equal({ 'webhooks' => { 'status' => WEBHOOK }, 'includeHtml' => true, 'sandbox' => true }, json_of(props))

    props = Copyleaks::SubmissionProperties.new(webhooks, nil, 'payload', nil, 24, 2)
    assert_equal 'payload', json_of(props)['developerPayload']
    assert_equal 24, json_of(props)['expiration']
    assert_equal 2, json_of(props)['sensitivityLevel']

    assert_raises(RuntimeError) { Copyleaks::SubmissionProperties.new(webhooks, nil, 123) }
    assert_raises(RuntimeError) { Copyleaks::SubmissionProperties.new(webhooks, nil, nil, nil, '24') }
    assert_raises(RuntimeError) { Copyleaks::SubmissionProperties.new(webhooks, nil, nil, nil, nil, 2.5) }
  end

  def test_all_positional_arguments_still_work
    props = Copyleaks::SubmissionProperties.new(
      webhooks, true, 'payload', true, 60, 1, true, Copyleaks::SubmissionActions::SCAN,
      Copyleaks::SubmissionAuthor.new('author-1'),
      Copyleaks::SubmissionFilter.new(true, true, true),
      Copyleaks::SubmissionScanning.new(true, nil, nil, Copyleaks::SubmissionScanningCopyleaksDB.new(true, true)),
      Copyleaks::SubmissionIndexing.new([Copyleaks::SubmissionRepository.new('repo-1')]),
      Copyleaks::SubmissionExclude.new(true, true, true, true, true),
      Copyleaks::SubmissionPDF.new(true, 'pdf-title', 'logo', false),
      Copyleaks::SubmissionSensitiveData.new(false),
      Copyleaks::SubmissionScanMethodAlgorithm::MAXIMUM_RESULTS,
      Copyleaks::SubmissionAiGeneratedText.new(true),
      [Copyleaks::SubmissionCustomMetadata.new('k', 'v')],
      Copyleaks::SubmissionWritingFeedback.new(true),
      'fr',
      Copyleaks::SubmissionAiSourceMatch.new(true)
    )
    json = json_of(props)
    assert_equal({ 'identicalEnabled' => true, 'minorChangesEnabled' => true, 'relatedMeaningEnabled' => true }, json['filters'])
    assert_equal({ 'internet' => true, 'copyleaksDb' => { 'includeMySubmissions' => true, 'includeOthersSubmissions' => true } },
                 json['scanning'])
    assert_equal({ 'repositories' => [{ 'id' => 'repo-1' }] }, json['indexing'])
    assert_equal({ 'create' => true, 'title' => 'pdf-title', 'largeLogo' => 'logo', 'rtl' => false }, json['pdf'])
    assert_equal({ 'driversLicense' => false }, json['sensitiveDataProtection'])
    assert_equal({ 'detect' => true }, json['aiGeneratedText'])
    assert_equal({ 'enable' => true }, json['writingFeedback'])
    assert_equal({ 'enable' => true }, json['aiSourceMatch'])
    assert_equal [{ 'key' => 'k', 'value' => 'v' }], json['customMetadata']
    assert_equal 'fr', json['displayLanguage']
    assert_equal 1, json['scanMethodAlgorithm']
    assert_equal 0, json['action']
    assert_equal({ 'id' => 'author-1' }, json['author'])
  end

  def test_new_property_keywords
    props = Copyleaks::SubmissionProperties.new(
      webhooks,
      overview: Copyleaks::SubmissionOverview.new(true, ignoreAIDetection: true, ignorePlagiarismDetection: false,
                                                        ignoreWritingFeedback: true, ignoreAuthorData: false),
      internalAiSourceMatch: Copyleaks::SubmissionInternalAiSourceMatch.new(true),
      references: Copyleaks::SubmissionReferences.new(true),
      scanTimeZone: 'America/New_York',
      course: Copyleaks::SubmissionCourse.new('course-1'),
      assignment: Copyleaks::SubmissionAssignment.new('assignment-1'),
      institution: Copyleaks::SubmissionInstitution.new('institution-1')
    )
    assert_equal({
                   'webhooks' => { 'status' => WEBHOOK },
                   'overview' => { 'enable' => true, 'ignoreAIDetection' => true, 'ignorePlagiarismDetection' => false,
                                   'ignoreWritingFeedback' => true, 'ignoreAuthorData' => false },
                   'internalAiSourceMatch' => { 'enable' => true },
                   'references' => { 'validate' => true },
                   'scanTimeZone' => 'America/New_York',
                   'course' => { 'id' => 'course-1' },
                   'assignment' => { 'id' => 'assignment-1' },
                   'institution' => { 'id' => 'institution-1' }
                 }, json_of(props))
    assert_equal({ 'enable' => true }, json_of(Copyleaks::SubmissionOverview.new(true)))
  end

  def test_new_property_keywords_are_type_checked
    assert_raises(RuntimeError) { Copyleaks::SubmissionProperties.new(webhooks, overview: true) }
    assert_raises(RuntimeError) { Copyleaks::SubmissionProperties.new(webhooks, references: { validate: true }) }
    assert_raises(RuntimeError) { Copyleaks::SubmissionProperties.new(webhooks, scanTimeZone: 3) }
    assert_raises(RuntimeError) { Copyleaks::SubmissionProperties.new(webhooks, course: 'course-1') }
    assert_raises(RuntimeError) { Copyleaks::SubmissionOverview.new('yes') }
    assert_raises(RuntimeError) { Copyleaks::SubmissionReferences.new('yes') }
    assert_raises(RuntimeError) { Copyleaks::SubmissionInternalAiSourceMatch.new(1) }
    assert_raises(RuntimeError) { Copyleaks::SubmissionInstitution.new(5) }
    assert_raises(ArgumentError) { Copyleaks::SubmissionProperties.new(webhooks, unknownOption: 1) }
  end

  def test_unset_booleans_are_not_sent_as_false
    assert_equal({}, json_of(Copyleaks::SubmissionFilter.new))
    assert_equal({}, json_of(Copyleaks::SubmissionScanning.new))
    assert_equal({}, json_of(Copyleaks::SubmissionExclude.new))
    assert_equal({}, json_of(Copyleaks::SubmissionExcludeCode.new))
    assert_equal({}, json_of(Copyleaks::SubmissionSensitiveData.new))
    assert_equal({}, json_of(Copyleaks::SubmissionAiGeneratedText.new))
    assert_equal({}, json_of(Copyleaks::SubmissionWritingFeedback.new))
    assert_equal({}, json_of(Copyleaks::SubmissionPDF.new))
    assert_equal({}, json_of(Copyleaks::SubmissionScanningCopyleaksDB.new))
    assert_equal({}, json_of(Copyleaks::SubmissionIndexing.new))

    # Setting one filter no longer turns paraphrase and minor-change detection off.
    assert_equal({ 'safeSearch' => true }, json_of(Copyleaks::SubmissionFilter.new(nil, nil, nil, nil, true)))
    # Adding a repository no longer turns internet scanning off.
    scanning = Copyleaks::SubmissionScanning.new(nil, nil, [Copyleaks::SubmissionScanningRepository.new('r', true, false)])
    assert_equal({ 'repositories' => [{ 'id' => 'r', 'includeMySubmissions' => true, 'includeOthersSubmissions' => false }] },
                 json_of(scanning))
    # An explicit false is still sent.
    assert_equal({ 'internet' => false }, json_of(Copyleaks::SubmissionScanning.new(false)))
    assert_equal({ 'minorChangesEnabled' => false }, json_of(Copyleaks::SubmissionFilter.new(nil, false)))
  end

  def test_pdf_colors_send_titles_and_new_colors
    colors = Copyleaks::SubmissionPdfColors.new('#000001', '#000002', '#000003', '#000004', '#000005',
                                                aiDetection: '#000006', writingFeedback: '#000007')
    assert_equal({ 'mainStrip' => '#000001', 'titles' => '#000002', 'identical' => '#000003', 'minorChanges' => '#000004',
                   'relatedMeaning' => '#000005', 'aiDetection' => '#000006', 'writingFeedback' => '#000007' }, json_of(colors))
    refute json_of(colors).key?('title')
    assert_equal '#000002', colors.title
  end

  def test_pdf_report_version_and_deprecated_version_constants
    pdf = Copyleaks::SubmissionPDF.new(true, nil, nil, nil, Copyleaks::SubmissionPdfVersion::V3, nil,
                                       Copyleaks::SubmissionPdfReportVersion::LATEST)
    assert_equal({ 'create' => true, 'version' => 3, 'reportVersion' => 'latest' }, json_of(pdf))
    assert_equal %w[v1 v2 v3], [Copyleaks::SubmissionPdfReportVersion::V1, Copyleaks::SubmissionPdfReportVersion::V2,
                                Copyleaks::SubmissionPdfReportVersion::V3]
  end

  def test_ai_generated_text_sensitivity_and_explain
    assert_equal({ 'detect' => true, 'sensitivity' => 1, 'explain' => { 'enable' => true } },
                 json_of(Copyleaks::SubmissionAiGeneratedText.new(true, sensitivity: 1,
                                                                        explain: Copyleaks::SubmissionAiGeneratedTextExplain.new(true))))
    assert_equal({ 'detect' => true, 'explain' => { 'enable' => false } },
                 json_of(Copyleaks::SubmissionAiGeneratedText.new(true, explain: false)))
    assert_raises(RuntimeError) { Copyleaks::SubmissionAiGeneratedText.new(true, sensitivity: 0) }
    assert_raises(RuntimeError) { Copyleaks::SubmissionAiGeneratedText.new(true, explain: 'on') }
  end

  def test_scanning_include_exclude_and_indexing_copyleaks_db
    scanning = Copyleaks::SubmissionScanning.new(
      true,
      Copyleaks::SubmissionScanningExclude.new('ex-*', backlinksDomains: ['example.com'], text: ['ignore me']),
      nil, nil,
      Copyleaks::SubmissionCrossLanguages.new([Copyleaks::SubmissionLanguage.new('fr')]),
      include: Copyleaks::SubmissionScanningInclude.new('in-*')
    )
    assert_equal({ 'internet' => true,
                   'exclude' => { 'idPattern' => 'ex-*', 'backlinksDomains' => ['example.com'], 'text' => ['ignore me'] },
                   'include' => { 'idPattern' => 'in-*' },
                   'crossLanguages' => { 'languages' => [{ 'code' => 'fr' }] } }, json_of(scanning))

    assert_raises(RuntimeError) { Copyleaks::SubmissionScanningExclude.new(nil, backlinksDomains: Array.new(11, 'a.com')) }
    assert_raises(RuntimeError) { Copyleaks::SubmissionScanningExclude.new(nil, text: Array.new(6, 'x')) }
    assert_raises(RuntimeError) { Copyleaks::SubmissionScanningExclude.new(nil, text: ['x' * 31]) }
    assert_raises(RuntimeError) { Copyleaks::SubmissionScanning.new(nil, include: 'in-*') }

    indexing = Copyleaks::SubmissionIndexing.new([Copyleaks::SubmissionIndexingRepository.new('r', 1)], copyleaksDb: true)
    assert_equal({ 'repositories' => [{ 'id' => 'r', 'maskingPolicy' => 1 }], 'copyleaksDb' => true }, json_of(indexing))
    assert_equal({ 'copyleaksDb' => false }, json_of(Copyleaks::SubmissionIndexing.new(copyleaksDb: false)))
  end

  def test_ai_image_response_new_fields
    payload = {
      'model' => 'ai-image-1-ultra',
      'result' => { 'starts' => [0, 10], 'lengths' => [5, 5], 'labels' => [4, 2] },
      'summary' => { 'human' => 0.3, 'ai' => 0.7 },
      'isAiDetected' => true,
      'imageInfo' => { 'shape' => { 'height' => 1024, 'width' => 768 },
                       'metadata' => { 'issuedTime' => 't', 'issuedBy' => 'OpenAI', 'appOrDeviceUsed' => 'API',
                                        'contentSummary' => 'Created using generative AI' } },
      'detectedObjects' => [{ 'object' => 'face', 'mask' => { 'starts' => [1024], 'lengths' => [512] } }],
      'scannedDocument' => { 'scanId' => 's', 'actualCredits' => 1, 'expectedCredits' => 1, 'creationTime' => 't' }
    }
    model = Copyleaks::CopyleaksAiImageDetectionResponseModel.from_json(payload)
    assert_equal [4, 2], model.result.labels
    assert model.is_ai_detected
    assert_equal 'Created using generative AI', model.image_info.metadata.content_summary
    assert_equal 'face', model.detected_objects.first.object
    assert_equal [1024], model.detected_objects.first.mask.starts
    assert_equal payload, JSON.parse(model.to_json)

    binary = Copyleaks::CopyleaksAiImageDetectionResponseModel.from_json('result' => { 'starts' => [1], 'lengths' => [2] })
    assert_nil binary.result.labels
    refute JSON.parse(binary.to_json)['result'].key?('labels')
    assert_nil binary.detected_objects
  end

  def test_ai_text_response_scanned_document
    payload = { 'summary' => { 'human' => 0, 'ai' => 1 },
                'scannedDocument' => { 'scanId' => 's1', 'totalWords' => 42, 'totalExcluded' => 0, 'actualCredits' => 1,
                                       'expectedCredits' => 1, 'creationTime' => '2026-01-01T00:00:00Z' } }
    model = Copyleaks::CopyleaksAiTextDetectionResponseModel.from_json(payload)
    assert_equal 's1', model.scanned_document.scan_id
    assert_equal 42, model.scanned_document.total_words
    assert_equal 1, model.scanned_document.actual_credits
    assert_equal payload['scannedDocument'], JSON.parse(model.to_json)['scannedDocument']
  end

  def test_text_moderation_response_from_a_hash_with_model_version
    payload = {
      'modelVersion' => 'v1',
      'moderations' => { 'text' => { 'chars' => { 'labels' => [0], 'starts' => [5], 'lengths' => [4] } } },
      'legend' => [{ 'index' => 0, 'id' => 'toxic-v1' }],
      'scannedDocument' => { 'scanId' => 's', 'totalWords' => 5, 'totalExcluded' => 0, 'actualCredits' => 1,
                             'expectedCredits' => 1, 'creationTime' => '2026-01-01T00:00:00Z' }
    }
    from_hash = Copyleaks::CopyleaksTextModerationResponseModel.from_json(payload)
    from_string = Copyleaks::CopyleaksTextModerationResponseModel.from_json(payload.to_json)
    [from_hash, from_string].each do |model|
      assert_equal 'v1', model.model_version
      assert_equal [5], model.moderations.text.chars.starts
      assert_equal 'toxic-v1', model.legend.first.id
      assert_equal 's', model.scanned_document.scan_id
      assert_equal Time.utc(2026, 1, 1), model.scanned_document.creation_time
    end
    assert_equal 'v1', JSON.parse(from_hash.to_json)['modelVersion']
  end

  def test_text_moderation_models_build_with_defaults
    model = Copyleaks::CopyleaksTextModerationResponseModel.new
    assert_nil model.scanned_document.creation_time
    assert_nil JSON.parse(model.to_json)['scannedDocument']['creationTime']
  end

  def test_completed_webhook_references_validation_and_internal_ai_data
    summary = { 'summary' => { 'total' => 5, 'academic' => 3, 'academicValidated' => 2, 'nonAcademicValidated' => 1 } }
    internal = [{ 'id' => 'i1', 'matchedWords' => 10, 'identicalWords' => 5, 'similarWords' => 3, 'paraphrasedWords' => 2,
                  'totalWords' => 100 }]
    results = Copyleaks::Results.new(internet: [], internalAIData: internal)
    webhook = Copyleaks::CompletedWebhook.new(status: 0, developerPayload: 'p', results: results, referencesValidation: summary)

    assert_equal summary, webhook.referencesValidation
    assert_equal internal, webhook.results.internalAIData
    json = JSON.parse(webhook.to_json)
    assert_equal summary, json['referencesValidation']
    assert_equal internal, json['results']['internalAIData']
    refute JSON.parse(Copyleaks::CompletedWebhook.new(status: 0).to_json).key?('referencesValidation')
    assert_raises(RuntimeError) { Copyleaks::Results.new(internalAIData: 'x') }
  end

  def test_new_result_webhook_internal_ai_data
    webhook = Copyleaks::NewResultWebhook.new(internalAIData: [{ 'id' => 'i1' }], developerPayload: 'p')
    assert_equal [{ 'id' => 'i1' }], webhook.internalAIData
    assert_equal [{ 'id' => 'i1' }], JSON.parse(webhook.to_json)['internalAIData']
  end

  def test_error_webhook_fields
    error_hash = { type: 'invalid_request_error', id: 'missing_parameter', code: 1, message: 'Bad request.',
                   url: 'https://docs.copyleaks.com/errors', details: [{ 'param' => 'filename', 'message' => 'missing' }] }
    error = Copyleaks::Error.new(**error_hash)
    assert_equal 'invalid_request_error', error.type
    assert_equal 'missing_parameter', error.id
    assert_equal [{ 'param' => 'filename', 'message' => 'missing' }], error.details
    assert_equal JSON.parse(error_hash.to_json), JSON.parse(error.to_json)

    minimal = Copyleaks::Error.new(code: 1, message: 'x')
    assert_equal({ 'code' => 1, 'message' => 'x' }, JSON.parse(minimal.to_json))
    Copyleaks::Error.new(code: 1, message: 'x', futureField: true) # unknown fields are tolerated
    assert_raises(RuntimeError) { Copyleaks::Error.new(type: 5) }
  end

  def test_internet_result_without_scan_id
    metadata = Copyleaks::Metadata.new(finalUrl: 'https://example.com')
    result = Copyleaks::Internet.new(tags: [], id: 'r1', title: 't', introduction: 'i', matchedWords: 3, metadata: metadata,
                                     url: 'https://example.com')
    assert_equal 'r1', result.id
    Copyleaks::NewResultsInternet.new(id: 'r1', title: 't', introduction: 'i', matchedWords: 3, metadata: metadata,
                                      url: 'https://example.com', scanId: 'legacy')
  end

  def test_multipart_form_body
    form = Copyleaks::MultipartForm.new('BOUNDARY')
    form.add_field('sandbox', true)
    form.add_file('image', "\xFF\x00".b, 'a.webp')
    expected = "--BOUNDARY\r\nContent-Disposition: form-data; name=\"sandbox\"\r\n\r\ntrue\r\n" \
               "--BOUNDARY\r\nContent-Disposition: form-data; name=\"image\"; filename=\"a.webp\"\r\n" \
               "Content-Type: image/webp\r\n\r\n\xFF\x00\r\n--BOUNDARY--\r\n".b
    assert_equal expected, form.body
    assert_equal 'multipart/form-data; boundary=BOUNDARY', form.content_type
    assert_equal 'application/octet-stream', Copyleaks::MultipartForm.content_type_for('file.xyz')
  end

  def test_multipart_form_rereads_io
    io = StringIO.new("\xFF\x00".b)
    first = Copyleaks::MultipartForm.new('BOUNDARY').add_file('image', io, 'a.png').body
    second = Copyleaks::MultipartForm.new('BOUNDARY').add_file('image', io, 'a.png').body
    assert_equal first, second
    assert_includes second, "\xFF\x00\r\n".b
  end

  def test_path_escaping
    assert_equal 'abc-123_x.y~', Copyleaks::ClientUtils.escape_path('abc-123_x.y~')
    assert_equal '%2F%3F%23%25%20%2B%22%3C%3E%7B%7D%7C%2A', Copyleaks::ClientUtils.escape_path('/?#% +"<>{}|*')
    assert_equal 'caf%C3%A9', Copyleaks::ClientUtils.escape_path('café')
  end

  def test_headers_validation
    assert Copyleaks::Utils.headers_valid?(nil)
    assert Copyleaks::Utils.headers_valid?([%w[A B], %w[C D]])
    refute Copyleaks::Utils.headers_valid?({ 'A' => 'B' })
    refute Copyleaks::Utils.headers_valid?([%w[A B C]])
    refute Copyleaks::Utils.headers_valid?([['A', 1]])
  end

  def test_video_scan_info_reuses_the_image_scanned_document
    video = Copyleaks::CopyleaksAiVideoDetectionScannedVideoModel.from_json('scanId' => 's', 'actualCredits' => 1)
    assert_kind_of Copyleaks::CopyleaksAiImageDetectionScannedDocumentModel, video
    assert_equal({ 'scanId' => 's', 'actualCredits' => 1 }, json_of(video))
    assert_nil Copyleaks::CopyleaksAiVideoDetectionScannedVideoModel.from_json('not a hash')

    image = Copyleaks::CopyleaksAiImageDetectionScannedDocumentModel.from_json('scanId' => 's', 'actualCredits' => 1)
    assert_instance_of Copyleaks::CopyleaksAiImageDetectionScannedDocumentModel, image
    assert_equal({ 'scanId' => 's', 'actualCredits' => 1, 'expectedCredits' => nil, 'creationTime' => nil }, json_of(image))
  end

  def test_ai_text_scanned_document_reuses_the_text_moderation_one
    payload = { 'scanId' => 's', 'totalWords' => 3, 'creationTime' => '2026-01-01T00:00:00.5Z' }
    text = Copyleaks::CopyleaksAiTextDetectionScannedDocumentModel.from_json(payload)
    assert_kind_of Copyleaks::TextModerationScannedDocument, text
    assert_equal '2026-01-01T00:00:00.5Z', text.creation_time
    assert_equal payload, json_of(text)
    assert_equal({}, json_of(Copyleaks::CopyleaksAiTextDetectionScannedDocumentModel.new))

    moderation = Copyleaks::TextModerationScannedDocument.from_json(payload.merge('creationTime' => '2026-01-01T00:00:00Z'))
    assert_equal Time.utc(2026, 1, 1), moderation.creation_time
    assert_equal '2026-01-01T00:00:00Z', json_of(moderation)['creationTime']
    assert_nil json_of(moderation)['actualCredits']
    assert_equal 0, Copyleaks::TextModerationScannedDocument.new.total_words
  end

  def test_export_pdf_report_and_crawled_version_are_export_targets
    [Copyleaks::ExportPdfReport, Copyleaks::ExportCrawledVersion].each do |klass|
      assert_operator klass, :<, Copyleaks::ExportTarget
      target = klass.new('https://example.com/e', 'POST', [%w[A B]])
      assert_equal({ 'endpoint' => 'https://example.com/e', 'verb' => 'POST', 'headers' => [%w[A B]] }, json_of(target))
      error = assert_raises(RuntimeError) { klass.new(1, 'POST') }
      assert_equal "Copyleaks::#{klass.name.split('::').last} - endpoint - endpoint must be of type String", error.message
    end
    # The export model still accepts only the matching class.
    assert_raises(RuntimeError) { Copyleaks::CopyleaksExportModel.new(WEBHOOK, nil, Copyleaks::ExportPdfReport.new('u', 'POST')) }
  end

  def test_id_and_enable_properties_share_a_base_class
    { Copyleaks::SubmissionCourse => 'c', Copyleaks::SubmissionAssignment => 'a', Copyleaks::SubmissionInstitution => 'i' }.each do |klass, id|
      assert_operator klass, :<, Copyleaks::IdObject
      assert_equal id, klass.new(id).id
      assert_equal({ 'id' => id }, json_of(klass.new(id)))
      error = assert_raises(RuntimeError) { klass.new(5) }
      assert_equal "Copyleaks::#{klass.name.split('::').last} - id - id must be of type String", error.message
    end
    assert_equal 'Copyleaks::IdObject - id - id must be of type String',
                 assert_raises(RuntimeError) { Copyleaks::IdObject.new(nil) }.message

    [Copyleaks::SubmissionAiSourceMatch, Copyleaks::SubmissionInternalAiSourceMatch,
     Copyleaks::SubmissionAiGeneratedTextExplain].each do |klass|
      assert_operator klass, :<, Copyleaks::SubmissionEnableFlag
      assert_equal false, klass.new(false).enable
      assert_equal({ 'enable' => false }, json_of(klass.new(false)))
      assert_equal({}, json_of(klass.new))
      error = assert_raises(RuntimeError) { klass.new('yes') }
      assert_equal "Copyleaks::#{klass.name.split('::').last} - enable - enable must be of type Boolean", error.message
    end
    # A shared base class does not make the properties interchangeable.
    assert_raises(RuntimeError) { Copyleaks::SubmissionProperties.new(webhooks, course: Copyleaks::SubmissionAssignment.new('a')) }
  end
end
