# Copyleaks SDK
The official [Copyleaks](https://copyleaks.com/) Ruby library.

Copyleaks is the integrity layer for your tech stack that helps organizations and individuals understand what's human-made and original, AI-generated, or manipulated across text, image, audio and video.

This SDK gives you access to the following Copyleaks products:

*   AI Text Detection
*   AI Image Detection (synchronous and asynchronous)
*   AI Video Detection
*   Plagiarism Checker (Authenticity scans: file, URL, OCR)
*   Image Plagiarism Detection
*   Grammar Checker
*   Text Moderation
*   Private Cloud Hub repository information

## 🚀 Getting Started
Before you start, ensure you have the following:

*   An active Copyleaks account. If you don’t have one, [sign up for free](https://copyleaks.com/signup).
*   You can find your API key on the [API Dashboard](https://api.copyleaks.com/dashboard).

Once you have your account and API key:

  **Install the SDK**:
  
  Install using [RubyGems](https://rubygems.org/gems/copyleaks)
```bash
gem install copyleaks
```
Or add it to your Gemfile:
```ruby
gem 'copyleaks'
```
This gem was previously published as `plagiarism-checker`. To switch, replace `plagiarism-checker` with `copyleaks` in your Gemfile or install command. `require 'copyleaks'` stays the same.

## 📚 Documentation
To learn more about how to use Copyleaks API please check out our [Documentation](https://docs.copyleaks.com/resources/sdks/ruby/). 

## Client options
`Copyleaks::API.new` takes optional keyword arguments. The defaults suit most applications.

```ruby
copyleaks = Copyleaks::API.new(
  open_timeout: 10,       # seconds to connect (TCP and TLS)
  read_timeout: 120,      # seconds to wait for each read of a response
  write_timeout: 120,     # seconds to wait for each write of a request body (raise it for large uploads on slow links)
  keep_alive_timeout: 30, # seconds an idle connection is kept for reuse
  pool_size: 5            # maximum open connections per Copyleaks server
)
```

- One `Copyleaks::API` instance is safe to share between threads (Puma, Sidekiq and other threaded servers). Each request uses its own pooled connection, and connections are reused between calls.
- Requests are never resent automatically. If a submit times out, the scan may still have been created: a second submit with the same scan id returns `409 Conflict`.
- `copyleaks.close` closes the idle connections. The client stays usable.
- `identity_server_uri:` and `api_server_uri:` override the server addresses for one client, without changing `Copyleaks::Config`.

### Errors
- `Copyleaks::CommandException`: the server rejected the request. `e.response` holds the status code, headers and body.
- `Copyleaks::RateLimitException` (HTTP 429) and `Copyleaks::UnderMaintenanceException` (HTTP 503): retry later with exponential backoff. `e.retry_after` returns the `Retry-After` header when the server sends one.
- `Copyleaks::AuthExpiredException`: the login token has expired, or expires within 5 minutes. Log in again.
- `Net::OpenTimeout`, `Net::ReadTimeout`, `Net::WriteTimeout` and socket errors: the request did not complete.

## 💡 Usage Examples
Here are some common usage examples for the Copyleaks SDK. You can also see a comprehensive code example in the `demo.rb` file on our GitHub repository: [demo.rb](https://github.com/Copyleaks/Ruby-Plagiarism-Checker/blob/master/demo/demo.rb).

### Get Authentication Token
This example demonstrates how to log in to the Copyleaks API and obtain an authentication token.

```ruby
require 'copyleaks'
require 'base64'

# --- Your Credentials ---
USER_EMAIL = 'YOUR_EMAIL_ADDRESS'
USER_API_KEY = 'YOUR_API_KEY'
# --------------------

begin
  # Log in to the Copyleaks API
  puts "Authenticating..."
  copyleaks = Copyleaks::API.new
  auth_token = copyleaks.login(USER_EMAIL, USER_API_KEY)
  puts "✅ Logged in successfully!"

end
```
For a detailed understanding of the authentication process, refer to the Copyleaks Login Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/account/login).
##
### Submit Text for Plagiarism Scan
This example shows how to prepare and submit raw text content for a plagiarism scan.

```ruby
require 'copyleaks'
require 'base64'

# --- Your Credentials ---
USER_EMAIL = 'YOUR_EMAIL_ADDRESS'
USER_API_KEY = 'YOUR_API_KEY'
WEBHOOK_URL = 'https://your-server.com'
# --------------------

begin
    scanId = DateTime.now.strftime('%Q').to_s
    submisson = Copyleaks::CopyleaksFileSubmissionModel.new(
      'aGVsbG8gd29ybGQ=',
      'ruby.txt',
      Copyleaks::SubmissionProperties.new(
        Copyleaks::SubmissionWebhooks.new("#{WEBHOOK_URL}/webhook/{STATUS}","#{WEBHOOK_URL}/url-webhook/new-result"),
        true,
        'developer_payloads_test',
        true,
        60,
        1,
        true,
        Copyleaks::SubmissionActions::SCAN,
        Copyleaks::SubmissionAuthor.new('Author_name'),
        Copyleaks::SubmissionFilter.new(true, true, true),
        Copyleaks::SubmissionScanning.new(true, nil, nil, Copyleaks::SubmissionScanningCopyleaksDB.new(true, true)),
        Copyleaks::SubmissionIndexing.new([Copyleaks::SubmissionRepository.new('repo-1')]),
        Copyleaks::SubmissionExclude.new(true, true, true, true, true),
        Copyleaks::SubmissionPDF.new(true, 'pdf-title', BASE64_LOGO, false),
        Copyleaks::SubmissionSensitiveData.new(false)
      )
    )

    @copyleaks.submit_file(_authToken, scanId, submisson)

end
```
For a full guide please refer to our step by step [Guide](https://docs.copyleaks.com/guides/authenticity/detect-plagiarism-text)

For a detailed understanding of the plagiarism detection process, refer to the Copyleaks Submit Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/authenticity/submit-file)

Only `webhooks` is required in `Copyleaks::SubmissionProperties`. Every other argument is optional: a value left `nil` is not sent, and the server default applies. Newer options are keyword arguments:

```ruby
properties = Copyleaks::SubmissionProperties.new(
  Copyleaks::SubmissionWebhooks.new("#{WEBHOOK_URL}/webhook/{STATUS}"),
  nil, nil, true, # includeHtml, developerPayload, sandbox
  overview: Copyleaks::SubmissionOverview.new(true, ignoreAuthorData: true),       # Gen-AI Overview
  internalAiSourceMatch: Copyleaks::SubmissionInternalAiSourceMatch.new(true),     # Internal AI Source Match
  references: Copyleaks::SubmissionReferences.new(true),                           # Citation Checker
  scanTimeZone: 'America/New_York',                                                # time zone of the PDF report
  course: Copyleaks::SubmissionCourse.new('course-1'),
  assignment: Copyleaks::SubmissionAssignment.new('assignment-1'),
  institution: Copyleaks::SubmissionInstitution.new('institution-1')
)
```
Other new options:
- `Copyleaks::SubmissionAiGeneratedText.new(true, sensitivity: 2, explain: true)`: AI detection sensitivity (1 to 3) and AI Logic explanations
- `Copyleaks::SubmissionScanning.new(true, exclude, repositories, copyleaks_db, cross_languages, include: Copyleaks::SubmissionScanningInclude.new('my-prefix-*'))`
- `Copyleaks::SubmissionScanningExclude.new('draft-*', backlinksDomains: ['example.com'], text: ['Sample header'])`
- `Copyleaks::SubmissionIndexing.new(repositories, copyleaksDb: true)`
- `Copyleaks::SubmissionPdfColors.new(main_strip, titles, identical, minor_changes, related_meaning, aiDetection: '#FE5758', writingFeedback: '#FF9A02')`
- `Copyleaks::CopyleaksURLSubmissionModel.new(url, properties, verb: 'POST', headers: [['Cookie', 'session=abc']])`
- `Copyleaks::CopyleaksDeleteRequestModel.new(scans, true, 'https://your-server.com/deleted', headers: [['Authorization', 'Bearer token']])`

`copyleaks.get_allowed_cross_languages` lists the language codes you can use with `Copyleaks::SubmissionCrossLanguages`. It needs no login.
##
### Export scan artifacts
Request any combination of artifacts. Only `completionWebhook` is required.

```ruby
model = Copyleaks::CopyleaksExportModel.new(
  'https://your-server.com/export/completed',
  nil,                                                                      # results
  nil,                                                                      # crawledVersion
  Copyleaks::ExportPdfReport.new('https://your-server.com/pdf', 'POST'),
  aiDetection: Copyleaks::ExportAiDetection.new('https://your-server.com/ai', 'POST'),
  writingFeedback: Copyleaks::ExportWritingFeedback.new('https://your-server.com/grammar', 'POST'),
  overview: Copyleaks::ExportOverview.new('https://your-server.com/overview', 'POST')
)
copyleaks.export(auth_token, scan_id, 'export-1', model)
```
For more details, refer to the Copyleaks Export Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/downloads/export)
##
### Reading the AI alert from the completed webhook
When AI Text Detection is enabled for a scan (`aiGeneratedText.detect`) and AI text is found, the completed webhook carries a `suspected-ai-text` alert in `notifications.alerts`. Its `additionalData` is the AI detection result, encoded as a JSON string. The SDK decodes it for you.

```ruby
require 'copyleaks'
require 'json'
require 'webrick'

# A WEBrick servlet, as in demo/webhookServer.rb. Mount it on your completed webhook URL:
#   server.mount '/webhook/completed', CompletedWebhookServlet
class CompletedWebhookServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(req, res)
    payload = JSON.parse(req.body)
    completed = Copyleaks::CompletedWebhook.new(**payload.transform_keys(&:to_sym))

    alert = completed.ai_detection_alert # Copyleaks::Alerts, or nil when the scan produced no AI alert
    if alert
      begin
        # nil when the alert has no data; raises JSON::ParserError when additionalData is not valid JSON
        ai_result = alert.ai_detection_result
        if ai_result && ai_result.summary
          puts "AI: #{ai_result.summary.ai}, human: #{ai_result.summary.human}, model: #{ai_result.model_version}"
          Array(ai_result.results).each do |result|
            # classification: 1 = human, 2 = AI
            Array(result.matches).each do |match|
              puts "classification #{result.classification}: starts #{match.text.chars.starts.inspect}, lengths #{match.text.chars.lengths.inspect}"
            end
          end
        end
      rescue JSON::ParserError => e
        warn "Could not decode the AI alert: #{e.message}"
      end
    end

    # Acknowledge the webhook even when the AI alert could not be decoded.
    res.status = 200
  end
end
```
- `ai_detection_alert` returns `nil` when the completed webhook contains no `suspected-ai-text` alert.
- `ai_detection_result` returns `nil` when the alert has no data or its data is not a JSON object, and raises `JSON::ParserError` when `additionalData` is not valid JSON. `completed.ai_detection_result` does the same in one call.
- The raw string is still available as `alert.additionalData`.

For more details on the alerts, refer to the Copyleaks scan alerts [Documentation](https://docs.copyleaks.com/reference/data-types/authenticity/scan-alerts)
##
### AI Text Detection
Use the AI detection client to determine if content was generated by artificial intelligence.

```ruby
require 'copyleaks'
require 'base64'

# --- Your Credentials ---
USER_EMAIL = 'YOUR_EMAIL_ADDRESS'
USER_API_KEY = 'YOUR_API_KEY'
# --------------------

begin
    scanId = DateTime.now.strftime('%Q').to_s
    text = "Lions are social animals, living in groups called prides, typically consisting of several females, their offspring, and a few males. Female lions are the primary hunters, working together to catch prey. Lions are known for their strength, teamwork, and complex social structures."
    submission = Copyleaks::NaturalLanguageSubmissionModel.new(
      text,
      nil,   # language: nil detects it automatically
      true,  # sandbox
      explain: true,  # AI Logic: the response includes the patterns behind the result
      sensitivity: 2  # 1 to 3
    )

    res = @copyleaks.ai_detection_client.submit_natural_language(_authToken, scanId, submission)
    result = Copyleaks::CopyleaksAiTextDetectionResponseModel.from_json(res)
    puts "AI: #{result.summary.ai}, human: #{result.summary.human}"

    # Credits available for AI Text Detection
    credits = @copyleaks.ai_detection_client.get_credits_balance(_authToken)['credits']

    # File types accepted by AI Text Detection (no login needed)
    file_types = @copyleaks.get_supported_ai_text_detection_file_types['supportedAiFileTypes']

end
```
For a full guide please refer to our step by step [Guide](https://docs.copyleaks.com/guides/ai-detector/ai-text-detection/)

For a detailed understanding of the AI Text Detection process, refer to the Copyleaks detect natural language Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/writer-detector/check/)
##
### Grammar Checker (WritingAssistantClient)
Get intelligent suggestions for improving grammar, spelling, style, and overall writing quality.

```ruby
require 'copyleaks'
require 'base64'

# --- Your Credentials ---
USER_EMAIL = 'YOUR_EMAIL_ADDRESS'
USER_API_KEY = 'YOUR_API_KEY'
# --------------------

begin
 text = "Lions are the only cat that live in groups, called pride. A prides typically consists of a few adult males, several feales, and their offspring. This social structure is essential for hunting and raising young cubs. Female lions, or lionesses are the primary hunters of the prid. They work together in cordinated groups to take down prey usually targeting large herbiores like zbras, wildebeest and buffalo. Their teamwork and strategy during hunts highlight the intelligence and coperation that are key to their survival."
    scanId = DateTime.now.strftime('%Q').to_s
    score_weights = Copyleaks::ScoreWeights.new(0.1, 0.2, 0.3, 0.4)
    submission = Copyleaks::WritingAssistantSubmissionModel.new(
      text,
    )
    submission.sandbox = true
    submission.score = score_weights
    res = @copyleaks.writing_assistant_client.submit_text(_authToken, scanId, submission)

end
```
For a full guide please refer to our step by step [Guide](https://docs.copyleaks.com/guides/writing/check-grammar/)

For a detailed understanding of the Grammar Checker (WritingAssistantClient) process, refer to the Copyleaks writing feedback Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/writing-assistant/check/)
##
### Text Moderation
Scan and moderate text content for unsafe, inappropriate, or policy-violating material across various categories.

```ruby
require 'copyleaks'
require 'base64'

# --- Your Credentials ---
USER_EMAIL = 'YOUR_EMAIL_ADDRESS'
USER_API_KEY = 'YOUR_API_KEY'
# --------------------

begin
    scanId = DateTime.now.strftime('%Q').to_s
    labelsArray=[
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::ADULT_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::TOXIC_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::VIOLENT_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::PROFANITY_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::SELF_HARM_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::HARASSMENT_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::HATE_SPEECH_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::DRUGS_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::FIREARMS_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::CYBERSECURITY_V1)
    ]
    
    text_moderation_request = Copyleaks::CopyleaksTextModerationRequestModel.new(
      text: "This is some text to scan.",
      sandbox: true,
      language: Copyleaks::CopyleaksTextModerationLanguages::ENGLISH,
      labels: labelsArray
    )
    res = @copyleaks.text_moderation_client.submit_text(_authToken, scanId, text_moderation_request)

    textModerationResponse = Copyleaks::CopyleaksTextModerationResponseModel.new(  
      moderations: res['moderations'],
      legend: res['legend'],
      scanned_document: res['scannedDocument'])

end
```
For a full guide please refer to our step by step [Guide](https://docs.copyleaks.com/guides/moderation/moderate-text/)

For a detailed understanding of the Text moderation process, refer to the Copyleaks text moderation Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/text-moderation/check/)
##
### AI Image Detection
Determine if a given image was generated or partially generated by an AI.

```ruby
    require 'copyleaks'
    require 'base64'
    # --- Your Credentials ---
    USER_EMAIL = 'YOUR_EMAIL_ADDRESS'
    USER_API_KEY = 'YOUR_API_KEY'
    # --------------------
  begin
      puts "Submitting a new image for AI image detection..."
      
      scanId = DateTime.now.strftime('%Q').to_s
      
      # Read and encode your image file to base64 (read it in binary mode)
      image_path = "Path/to/your/image.jpg" # Update this path to your image
      base64_image = Base64.strict_encode64(File.binread(image_path))
      
      model = Copyleaks::CopyleaksAiImageDetectionRequestModel.new(
        base64_image,
        "image.jpg",
        Copyleaks::CopyleaksAiImageDetectionModels::AI_IMAGE_1_ULTRA, 
        true # sandbox mode
      )
      
      res = copyleaks.ai_image_detection_client.submit_(authToken, scanId, model)
    rescue StandardError => e
      puts "Error in test_image_detection: #{e.message}"
    end
  end
```
For a full guide please refer to our step by step [Guide](https://docs.copyleaks.com/guides/ai-detector/ai-image-detection/)

For a detailed understanding of the AI Image Detection process, refer to the Copyleaks AI image detection Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/ai-image-detector/check/)

To upload the raw image as multipart/form-data, which skips the base64 overhead, pass `nil` as the first argument and the bytes as `image:`. You can also pick the detection mask and locate objects:

```ruby
model = Copyleaks::CopyleaksAiImageDetectionRequestModel.new(
  nil, 'image.jpg', Copyleaks::CopyleaksAiImageDetectionModels::AI_IMAGE_1_ULTRA, true,
  image: File.binread('Path/to/your/image.jpg'),
  mask_type: Copyleaks::CopyleaksAiImageMaskTypes::HEATMAP, # BINARY (default), HEATMAP or NONE
  object_detection: ['face', 'hand']                        # up to 3 objects
)
res = copyleaks.ai_image_detection_client.check(authToken, scanId, model) # same as submit_
result = Copyleaks::CopyleaksAiImageDetectionResponseModel.from_json(res)
puts "AI detected: #{result.is_ai_detected}, objects: #{Array(result.detected_objects).map(&:object)}"
```
`model.validate!` runs optional client-side checks (file name, extension and size) before you send the request.
##
### AI Image Detection (asynchronous)
Submit an image URL. The server answers right away and posts the result to your webhook. The webhook body has the same shape as the synchronous result, so `Copyleaks::CopyleaksAiImageDetectionResponseModel.from_json(JSON.parse(body))` reads it.

```ruby
model = Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel.new(
  url: 'https://example.com/image.png',
  file_name: 'image.png',
  model: Copyleaks::CopyleaksAiImageDetectionModels::AI_IMAGE_1_ULTRA,
  webhooks: Copyleaks::CopyleaksAsyncWebhooksModel.new('https://your-server.com/webhook/ai-image'),
  mask_type: Copyleaks::CopyleaksAiImageMaskTypes::HEATMAP,
  sandbox: true
)
copyleaks.ai_image_detection_client.submit_async(authToken, scanId, model)
```
For more details, refer to the Copyleaks AI Image Detector Async Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/ai-image-detector/submit)
##
### AI Video Detection
Submit a video URL. The server answers right away and posts the result to your webhook.

```ruby
model = Copyleaks::CopyleaksAiVideoDetectionRequestModel.new(
  url: 'https://example.com/video.mp4',
  filename: 'video.mp4',
  model: Copyleaks::CopyleaksAiVideoDetectionModels::AI_VIDEO_1_PRO,
  webhooks: Copyleaks::CopyleaksAsyncWebhooksModel.new('https://your-server.com/webhook/ai-video'),
  sandbox: true
)
copyleaks.ai_video_detection_client.submit(authToken, scanId, model)

# In your webhook handler:
result = Copyleaks::CopyleaksAiVideoDetectionResponseModel.from_json(JSON.parse(request_body))
puts "AI detected: #{result.is_ai_detected}, overall ratio: #{result.summary.overall_ai_ratio}"
```
For more details, refer to the Copyleaks AI Video Detection Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/ai-video-detector/submit)
##
### Image Plagiarism Detection
Search the web for copies of an image. The image is uploaded as multipart/form-data and the matches are in the response.

```ruby
model = Copyleaks::CopyleaksImagePlagiarismRequestModel.new(
  image: File.binread('Path/to/your/photo.jpg'),
  filename: 'photo.jpg',
  sandbox: true
)
res = copyleaks.image_plagiarism_client.check(authToken, scanId, model)
result = Copyleaks::CopyleaksImagePlagiarismResponseModel.from_json(res)
puts "Matches: #{result.matches.score.total_matches}"
result.matches.internet.each { |match| puts "#{match.url} (#{match.match_type == 0 ? 'full' : 'partial'})" }
```
For more details, refer to the Copyleaks Image Plagiarism Detection Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/image-plagiarism-detector/check)
##
### Account and lookups

```ruby
copyleaks.get_credits_balance(authToken)                      # plagiarism credits
copyleaks.ai_detection_client.get_credits_balance(authToken)  # AI Text Detection credits
copyleaks.get_repository_info(authToken, 'my-repo-id')        # Private Cloud Hub repository (Admin role)

# Usage history as CSV. With a block, the CSV is streamed in chunks.
File.open('usage.csv', 'w') do |file|
  copyleaks.get_usages_history_csv(authToken, '01-09-2026', '30-09-2026') { |chunk| file.write(chunk) }
end

# Public lookups, no login needed
copyleaks.get_supported_file_types
copyleaks.get_supported_ai_text_detection_file_types
copyleaks.get_allowed_cross_languages
copyleaks.get_ocr_supported_languages
```

##
### Further Resources

*   **Copyleaks API Dashboard:** Manage your API keys, monitor usage, and view analytics from your personalized dashboard. [Access Dashboard](https://api.copyleaks.com/dashboard)
*   **Copyleaks SDK Documentation:** Explore comprehensive guides, API references, and code examples for seamless integration. [Read Documentation](https://docs.copyleaks.com/resources/sdks/overview/)


## Development
The offline test suite runs against a local stub server and never calls the Copyleaks API:

```bash
rake test
```

## Support
* If you need assistance, please contact Copyleaks Support via our support portal: Contact Copyleaks [Support](https://help.copyleaks.com/s/contactsupport).
* To arrange a product demonstration, book a demo here: [Booking Link](https://copyleaks.com/book-a-demo).
