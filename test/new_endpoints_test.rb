# frozen_string_literal: true

require_relative 'test_helper'

# Wire-level checks for the endpoints added in 5.0.
class NewEndpointsTest < Minitest::Test
  include CopyleaksTestHelpers

  def test_image_plagiarism_check_uploads_multipart
    @server.respond do |_req|
      [200, {}, { developerPayload: 'p1', scannedImage: { scanId: 'img1', width: 4, height: 4, filename: 'photo.png' },
                  matches: { internet: [{ url: 'https://example.com/a.png', matchType: 0, webPages: [{ url: 'https://example.com/a' }] }],
                             score: { totalMatches: 1, fullMatches: 1, partialMatches: 0 } } }.to_json]
    end
    request = Copyleaks::CopyleaksImagePlagiarismRequestModel.new(image: png_bytes, filename: 'photo.png', sandbox: true,
                                                                   developer_payload: 'p1')
    result = api.image_plagiarism_client.check(token, 'img 1', request)

    req = @server.last_request
    assert_equal 'POST', req.method
    assert_equal '/v1/image-plagiarism-detector/img%201/check', req.path
    assert_match %r{\Amultipart/form-data; boundary=\S+\z}, req.headers['content-type']
    assert_equal 'Bearer test-access-token', req.headers['authorization']
    assert_equal "ruby-sdk/#{Copyleaks::VERSION}", req.headers['user-agent']
    assert_equal req.body.bytesize.to_s, req.headers['content-length']

    parts = multipart_parts(req)
    assert_equal %w[developerPayload filename image sandbox], parts.keys.sort
    assert_equal 'photo.png', parts['image'][:filename]
    assert_equal 'image/png', parts['image'][:content_type]
    assert_equal png_bytes, parts['image'][:value]
    assert_equal 'photo.png', parts['filename'][:value]
    assert_equal 'true', parts['sandbox'][:value]
    assert_equal 'p1', parts['developerPayload'][:value]

    model = Copyleaks::CopyleaksImagePlagiarismResponseModel.from_json(result)
    assert_equal 'p1', model.developer_payload
    assert_equal 'img1', model.scanned_image.scan_id
    assert_equal 1, model.matches.score.total_matches
    assert_equal Copyleaks::CopyleaksImagePlagiarismInternetMatchModel::FULL, model.matches.internet.first.match_type
    assert_equal ['https://example.com/a'], model.matches.internet.first.web_pages
    assert_equal JSON.parse(result.to_json), JSON.parse(model.to_json)
  end

  def test_image_plagiarism_minimal_request_and_io_input
    request = Copyleaks::CopyleaksImagePlagiarismRequestModel.new(image: StringIO.new(png_bytes), filename: 'a"b.jpg')
    api.image_plagiarism_client.check(token, 'img1', request)

    parts = multipart_parts(@server.last_request)
    assert_equal %w[filename image], parts.keys.sort
    assert_equal 'a%22b.jpg', parts['image'][:filename], 'quotes in file names must be escaped'
    assert_equal 'image/jpeg', parts['image'][:content_type]
    assert_equal png_bytes, parts['image'][:value]
  end

  def test_image_plagiarism_request_validation
    assert_raises(ArgumentError) { Copyleaks::CopyleaksImagePlagiarismRequestModel.new(image: 123, filename: 'a.png') }
    assert_raises(ArgumentError) { Copyleaks::CopyleaksImagePlagiarismRequestModel.new(image: 'x', filename: '') }
    assert_raises(ArgumentError) { Copyleaks::CopyleaksImagePlagiarismRequestModel.new(image: 'x', filename: "#{'a' * 252}.png") }
    assert_raises(ArgumentError) { Copyleaks::CopyleaksImagePlagiarismRequestModel.new(image: 'x', filename: 'a.png', sandbox: 'yes') }
    assert_raises(RuntimeError) { api.image_plagiarism_client.check(token, 'img1', 'not a model') }
  end

  def test_ai_video_submit
    @server.respond { |_req| [201, {}, '{}'] }
    request = Copyleaks::CopyleaksAiVideoDetectionRequestModel.new(
      url: 'https://example.com/v.mp4',
      filename: 'v.mp4',
      model: Copyleaks::CopyleaksAiVideoDetectionModels::AI_VIDEO_1_PRO,
      webhooks: Copyleaks::CopyleaksAsyncWebhooksModel.new('https://example.com/hook', [%w[Authorization Bearer-x]]),
      headers: [%w[X-Auth t]],
      verb: 'GET',
      sandbox: true,
      developer_payload: 'order-1'
    )
    assert_equal({}, api.ai_video_detection_client.submit(token, 'vid1', request))

    req = @server.last_request
    assert_equal 'POST', req.method
    assert_equal '/v1/ai-video-detector/vid1/submit', req.path
    assert_json_headers(req)
    assert_equal({
                   'url' => 'https://example.com/v.mp4',
                   'headers' => [%w[X-Auth t]],
                   'verb' => 'GET',
                   'filename' => 'v.mp4',
                   'model' => 'ai-video-1-pro',
                   'webhooks' => { 'url' => 'https://example.com/hook', 'headers' => [%w[Authorization Bearer-x]] },
                   'sandbox' => true,
                   'developerPayload' => 'order-1'
                 }, json_body(req))
  end

  def test_ai_video_minimal_request
    request = Copyleaks::CopyleaksAiVideoDetectionRequestModel.new(url: 'https://example.com/v.mp4', filename: 'v.mp4',
                                                                   model: 'ai-video-1-pro', webhooks: 'https://example.com/hook')
    assert_equal({ 'url' => 'https://example.com/v.mp4', 'filename' => 'v.mp4', 'model' => 'ai-video-1-pro',
                   'webhooks' => { 'url' => 'https://example.com/hook' } }, json_of(request))
    assert_raises(ArgumentError) do
      Copyleaks::CopyleaksAiVideoDetectionRequestModel.new(url: 'u', filename: 'v.mp4', model: 'm', webhooks: 'w', verb: 'DELETE')
    end
    assert_raises(ArgumentError) do
      Copyleaks::CopyleaksAiVideoDetectionRequestModel.new(url: 'u', filename: 'v.mp4', model: 'm', webhooks: 42)
    end
    assert_raises(ArgumentError) do
      Copyleaks::CopyleaksAiVideoDetectionRequestModel.new(url: 'u', filename: 'v.mp4', model: 'm', webhooks: 'w', headers: ['bad'])
    end
  end

  def test_ai_video_webhook_payload_model
    payload = {
      'model' => 'ai-video-1-pro',
      'audioResult' => { 'starts' => [13_000], 'lengths' => [14_000], 'exclude' => { 'starts' => [0], 'lengths' => [2950] } },
      'visualResult' => { 'starts' => [11_566], 'lengths' => [6134], 'exclude' => { 'starts' => [], 'lengths' => [] } },
      'summary' => { 'audioAIRatio' => 0.49, 'visualAIRatio' => 0.58, 'overallAIRatio' => 0.75 },
      'isAiDetected' => true,
      'videoInfo' => { 'metadata' => { 'issuedTime' => '2026-03-17T13:14:57+00:00', 'issuedBy' => 'OpenAI',
                                       'appOrDeviceUsed' => 'Sora', 'contentSummary' => 'Created using generative AI' },
                       'duration' => 55.7 },
      'scannedVideo' => { 'scanId' => 'vid1', 'actualCredits' => 1, 'expectedCredits' => 1, 'creationTime' => '2026-05-05T12:37:50Z' }
    }
    model = Copyleaks::CopyleaksAiVideoDetectionResponseModel.from_json(payload)

    assert_equal 0.75, model.summary.overall_ai_ratio
    assert_equal [13_000], model.audio_result.starts
    assert_equal [2950], model.audio_result.exclude.lengths
    assert model.is_ai_detected
    assert_equal 55.7, model.video_info.duration
    assert_equal 'Sora', model.video_info.metadata.app_or_device_used
    assert_equal 'Created using generative AI', model.video_info.metadata.content_summary
    assert_equal 'vid1', model.scanned_video.scan_id
    assert_equal payload, JSON.parse(model.to_json)
  end

  def test_ai_image_async_submit
    @server.respond { |_req| [201, {}, ''] }
    request = Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel.new(
      url: 'https://example.com/i.png',
      file_name: 'i.png',
      model: Copyleaks::CopyleaksAiImageDetectionModels::AI_IMAGE_1_ULTRA,
      webhooks: Copyleaks::CopyleaksAsyncWebhooksModel.new('https://example.com/hook'),
      mask_type: Copyleaks::CopyleaksAiImageMaskTypes::HEATMAP,
      object_detection: [{ object: 'face' }],
      headers: [%w[X-Auth t]],
      sandbox: true,
      developer_payload: 'p'
    )
    assert_nil api.ai_image_detection_client.submit_async(token, 'img/1', request)

    req = @server.last_request
    assert_equal 'PUT', req.method
    assert_equal '/v1/ai-image-detector-async/img%2F1/submit', req.path
    assert_json_headers(req)
    assert_equal({
                   'url' => 'https://example.com/i.png',
                   'fileName' => 'i.png',
                   'model' => 'ai-image-1-ultra',
                   'maskType' => 'heatmap',
                   'objectDetection' => [{ 'object' => 'face' }],
                   'headers' => [%w[X-Auth t]],
                   'webhooks' => { 'url' => 'https://example.com/hook' },
                   'sandbox' => true,
                   'developerPayload' => 'p'
                 }, json_body(req))
  end

  def test_ai_image_async_minimal_request
    request = Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel.new(url: 'https://example.com/i.png', file_name: 'i.png',
                                                                        model: 'ai-image-1-ultra', webhooks: 'https://example.com/hook')
    assert_equal({ 'url' => 'https://example.com/i.png', 'fileName' => 'i.png', 'model' => 'ai-image-1-ultra',
                   'webhooks' => { 'url' => 'https://example.com/hook' } }, json_of(request))
    assert_raises(RuntimeError) { api.ai_image_detection_client.submit_async(token, 'img1', 'not a model') }
  end

  def test_ai_text_credits
    @server.respond { |_req| [200, {}, '{"credits":382}'] }
    assert_equal({ 'credits' => 382 }, api.ai_detection_client.get_credits_balance(token))

    req = @server.last_request
    assert_equal 'GET', req.method
    assert_equal '/v2/writer-detector/credits', req.path
    assert_json_headers(req)
    assert_equal '', req.body
  end

  def test_allowed_cross_languages_is_public
    body = { documentLanguages: { english: 'en' }, resultLanguages: { french: 'fr' } }.to_json
    @server.respond { |_req| [200, {}, body] }
    assert_equal({ 'documentLanguages' => { 'english' => 'en' }, 'resultLanguages' => { 'french' => 'fr' } },
                 api.get_allowed_cross_languages)

    req = @server.last_request
    assert_equal 'GET', req.method
    assert_equal '/v3/miscellaneous/allowed-cross-languages', req.path
    assert_json_headers(req, authorized: false)
  end

  def test_supported_ai_text_detection_file_types_is_public
    @server.respond { |_req| [200, {}, '{"supportedAiFileTypes":["pdf","docx"]}'] }
    assert_equal({ 'supportedAiFileTypes' => %w[pdf docx] }, api.get_supported_ai_text_detection_file_types)

    req = @server.last_request
    assert_equal 'GET', req.method
    assert_equal '/v3/miscellaneous/supported-ai-text-detection-file-types', req.path
    assert_json_headers(req, authorized: false)
  end

  def test_repository_info
    info = { 'id' => 'repo 1', 'name' => 'Hub', 'permission' => 4, 'status' => 0, 'maxCredits' => 1000,
             'currentCredits' => 900, 'maskingPolicy' => 0, 'creationTime' => '2024-09-09T10:43:52' }
    @server.respond { |_req| [200, {}, info.to_json] }
    assert_equal info, api.get_repository_info(token, 'repo 1')

    req = @server.last_request
    assert_equal 'GET', req.method
    assert_equal '/v3/repositories/repository/repo%201/info', req.path
    assert_json_headers(req)

    assert_raises(RuntimeError) { api.get_repository_info(token, '') }
    assert_raises(RuntimeError) { api.get_repository_info(token, nil) }
  end
end
