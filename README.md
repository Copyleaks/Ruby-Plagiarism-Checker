# Copyleaks SDK
The official [Copyleaks](https://copyleaks.com/) Ruby library.

Copyleaks is the integrity layer for your tech stack that helps organizations and individuals understand what's human-made and original, AI-generated, or manipulated across text, image, audio and video.

This SDK gives you access to the following Copyleaks products:

*   AI Text Detection
*   AI Image Detection
*   Plagiarism Checker (Authenticity scans: file, URL, OCR)
*   Grammar Checker
*   Text Moderation

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

For a detailed understanding of the plagiarism detection process, refer to the Copyleaks Submit Endpoint [Documentation](https://docs.copyleaks.com/reference/actions/scans/submit-file)
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
    )
    submission.sandbox = true
    
    res = @copyleaks.ai_detection_client.submit_natural_language(_authToken, scanId, submission)

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
      
      # Read and encode your image file to base64
      image_path = "Path/to/your/image.jpg" # Update this path to your image
      base64_image = Base64.strict_encode64(File.read(image_path))
      
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

##
### Further Resources

*   **Copyleaks API Dashboard:** Manage your API keys, monitor usage, and view analytics from your personalized dashboard. [Access Dashboard](https://api.copyleaks.com/dashboard)
*   **Copyleaks SDK Documentation:** Explore comprehensive guides, API references, and code examples for seamless integration. [Read Documentation](https://docs.copyleaks.com/resources/sdks/overview/)


## Support
* If you need assistance, please contact Copyleaks Support via our support portal: Contact Copyleaks [Support](https://help.copyleaks.com/s/contactsupport).
* To arrange a product demonstration, book a demo here: [Booking Link](https://copyleaks.com/book-a-demo).
