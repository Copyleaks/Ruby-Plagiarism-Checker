# Changelog

All notable changes to the Copyleaks Ruby SDK are listed here.

## 5.0.0

The gem is now published as `copyleaks`. Versions up to 4.1.1 were published as `plagiarism-checker`. The Ruby code you write does not change: `require 'copyleaks'` and the `Copyleaks` module are the same as before. Read the upgrade notes below.

### Added

- **New submit properties.**
  - `Copyleaks::SubmissionAiSourceMatch.new(true)`, passed as the new `aiSourceMatch` argument of `Copyleaks::SubmissionProperties`: finds online sources suspected of containing AI-generated text. It currently applies only to documents detected as English. When you leave it `nil`, the server default (disabled) applies.
  - `displayLanguage` argument of `Copyleaks::SubmissionProperties`: the language of the scan's PDF report. One of `'en'`, `'es'`, `'pt'`, `'fr'`, `'de'`, `'it'` (lowercase, case-sensitive). The server default is `'en'`.
  - `reportVersion` argument of `Copyleaks::SubmissionPDF`: which version of the PDF report to generate. One of `'v1'`, `'v2'`, `'v3'`, `'latest'` (lowercase, case-sensitive). It overrides `version` when both are set.
  - The new arguments come after the existing ones and default to `nil`, so existing calls keep working. A value of the wrong type raises an error. A `nil` value is left out of the request.
- **AI alert in the completed webhook.**
  - `Copyleaks::CompletedWebhook#ai_detection_alert` returns the `suspected-ai-text` alert as a `Copyleaks::Alerts`, or `nil` when the scan has no AI alert. It works whether `notifications` is the raw Hash from the webhook body or a `Copyleaks::Notifications` object. A malformed AI alert raises: `ArgumentError` when `severity` or `category` is missing, or `RuntimeError` when a field has the wrong type. The API always sends both fields.
  - `Copyleaks::Alerts#ai_detection_result` and the shortcut `Copyleaks::CompletedWebhook#ai_detection_result` decode the alert's `additionalData` JSON string into a `Copyleaks::CopyleaksAiTextDetectionResponseModel`, with `summary.ai`, `summary.human`, `model_version`, `results`, `translation` and `explain`. They return `nil` when there is no AI alert, or when the data is empty or is JSON that is not an object. They raise `JSON::ParserError` when `additionalData` is not valid JSON. The raw string stays available as `alert.additionalData`.
  - `Copyleaks::Alerts.from_json(hash)` builds an alert from a webhook alert Hash with String or Symbol keys.
  - New constant `Copyleaks::CopyleaksAlertCodes::SUSPECTED_AI_TEXT` (`"suspected-ai-text"`).
  - New AI Text Detection model classes, loaded by `require 'copyleaks'`.
- **Image Plagiarism Detection.** `api.image_plagiarism_client.check(token, scan_id, model)` searches the web for copies of an image. Build the request with `Copyleaks::CopyleaksImagePlagiarismRequestModel.new(image: File.binread(path), filename: 'photo.jpg', sandbox: true)`. The image is uploaded as multipart/form-data. `Copyleaks::CopyleaksImagePlagiarismResponseModel.from_json(result)` reads the matches.
- **AI Video Detection.** `api.ai_video_detection_client.submit(token, scan_id, model)` submits a video URL with `Copyleaks::CopyleaksAiVideoDetectionRequestModel` (`url:`, `filename:`, `model:`, `webhooks:`, and optional `headers:`, `verb:`, `sandbox:`, `developer_payload:`). The result is posted to your webhook; `Copyleaks::CopyleaksAiVideoDetectionResponseModel.from_json` reads it. New constant `Copyleaks::CopyleaksAiVideoDetectionModels::AI_VIDEO_1_PRO`.
- **Asynchronous AI Image Detection.** `api.ai_image_detection_client.submit_async(token, scan_id, model)` submits an image URL with `Copyleaks::CopyleaksAiImageDetectionAsyncRequestModel`. The result is posted to your webhook in the same shape as the synchronous result. `Copyleaks::CopyleaksAsyncWebhooksModel.new(url, headers)` sets the webhook for both asynchronous detectors.
- **New lookups.**
  - `api.ai_detection_client.get_credits_balance(token)`: the AI Text Detection credit balance.
  - `api.get_repository_info(token, repository_id)`: a Private Cloud Hub repository's credits, masking policy and status.
  - `api.get_allowed_cross_languages` and `api.get_supported_ai_text_detection_file_types`. Both are public and need no login.
- **AI Image Detection options.**
  - `mask_type:` (`Copyleaks::CopyleaksAiImageMaskTypes::BINARY`, `HEATMAP` or `NONE`) and `object_detection:` (up to 3 object names, for example `['face']`) on `Copyleaks::CopyleaksAiImageDetectionRequestModel`.
  - `image:` sends the raw image bytes as multipart/form-data, without the base64 overhead. Pass `nil` as the base64 argument.
  - `check` is a clearer alias of `submit_`.
- **AI Text Detection options.** `explain:` (AI Logic) and `sensitivity:` (1 to 3) on `Copyleaks::NaturalLanguageSubmissionModel`.
- **More scan properties.** All are optional and left out of the request when `nil`.
  - Keyword arguments of `Copyleaks::SubmissionProperties`: `overview:` (`Copyleaks::SubmissionOverview`, Gen-AI Overview), `internalAiSourceMatch:` (`Copyleaks::SubmissionInternalAiSourceMatch`), `references:` (`Copyleaks::SubmissionReferences`, Citation Checker), `scanTimeZone:`, `course:`, `assignment:` and `institution:` (`Copyleaks::SubmissionCourse`, `SubmissionAssignment`, `SubmissionInstitution`).
  - `sensitivity:` and `explain:` on `Copyleaks::SubmissionAiGeneratedText`.
  - `include:` (`Copyleaks::SubmissionScanningInclude`) on `Copyleaks::SubmissionScanning`.
  - `backlinksDomains:` and `text:` on `Copyleaks::SubmissionScanningExclude`.
  - `copyleaksDb:` on `Copyleaks::SubmissionIndexing`.
  - `aiDetection:` and `writingFeedback:` colors on `Copyleaks::SubmissionPdfColors`.
  - Constants `Copyleaks::SubmissionPdfReportVersion` (`V1`, `V2`, `V3`, `LATEST`) and `Copyleaks::SubmissionPdfVersion::V3`.
- **More request fields.**
  - `verb:` and `headers:` on `Copyleaks::CopyleaksURLSubmissionModel`, to scan pages that need a POST or custom headers.
  - `headers:` on `Copyleaks::CopyleaksDeleteRequestModel`, for the completion webhook.
  - Export targets `aiDetection:`, `writingFeedback:` and `overview:` on `Copyleaks::CopyleaksExportModel`, built with `Copyleaks::ExportAiDetection`, `ExportWritingFeedback` and `ExportOverview`.
- **More response and webhook fields.**
  - AI Image Detection: `is_ai_detected`, `detected_objects`, `result.labels` (heatmap) and `image_info.metadata.content_summary`.
  - AI Text Detection: `scanned_document`.
  - Text Moderation: `model_version`.
  - Completed webhook: `referencesValidation`, and `internalAIData` in `Copyleaks::Results`. New-result webhook: `internalAIData`.
  - Error webhook: `type`, `id`, `url` and `details` in `Copyleaks::Error`.
- **Connection settings.** `Copyleaks::API.new` accepts `open_timeout:`, `read_timeout:`, `write_timeout:`, `keep_alive_timeout:`, `pool_size:`, `identity_server_uri:` and `api_server_uri:`. `api.close` closes idle connections.
- **Retry information.** `Copyleaks::RateLimitException` and `Copyleaks::UnderMaintenanceException` now carry the HTTP `response`, and `retry_after` returns the `Retry-After` header.
- **Streamed usage history.** Pass a block to `get_usages_history_csv` to receive the CSV in chunks instead of one String.
- **Tests.** The repository has an offline test suite: `rake test`.

### Changed

- **Gem renamed to `copyleaks`.** See the upgrade notes below.
- **The gem no longer installs the `console` and `setup` executables.** These are development scripts from the repository's `bin/` folder, and 4.x installed them as commands.
- **`Copyleaks::Alerts` accepts the webhook's own types.** `category` and `severity` can be Integers, as the webhook sends them. Strings are still accepted. `title`, `message`, `helpLink` and `additionalData` are now optional. `to_json` leaves out fields that are `nil`.
- **Connections are reused and safe to share between threads.** Each `Copyleaks::API` keeps a small pool of persistent connections, so a call no longer opens a new TCP and TLS connection, and one instance can be shared by Puma, Sidekiq or any threaded code.
- **Timeouts.** The defaults are 10 seconds to connect and 120 seconds to read or write, and you can change them. Earlier versions used fixed 60 second timeouts.
- **Requests are never resent automatically.** Earlier versions could upload a submit a second time after a read timeout, and the second upload failed with `409 Conflict`.
- **Unset fields are left out of requests.** Arguments that are not set now default to `nil` and are not sent, so the server default applies. This covers `Copyleaks::SubmissionFilter`, `SubmissionScanning`, `SubmissionExclude`, `SubmissionExcludeCode`, `SubmissionSensitiveData`, `SubmissionAiGeneratedText`, `SubmissionWritingFeedback`, the `sandbox` of the AI Text, AI Image, Grammar Checker and Text Moderation requests, and `purge` and `completionWebhook` of `Copyleaks::CopyleaksDeleteRequestModel`.
- **More arguments are optional.** `developerPayload`, `expiration` and `sensitivityLevel` of `Copyleaks::SubmissionProperties`; every argument of `Copyleaks::SubmissionPDF` and `Copyleaks::SubmissionScanningCopyleaksDB`; `repositories` of `Copyleaks::SubmissionIndexing`; `idPattern` of `Copyleaks::SubmissionScanningExclude`; `results` and `crawledVersion` of `Copyleaks::CopyleaksExportModel`; `code` and `message` of `Copyleaks::Error`; `scanId` of `Copyleaks::NewResultsInternet`.
- **Text Moderation accepts at most 16 labels**, the API limit. The earlier limit was 32.
- **AI Image Detection sends `filename`**, the documented field name, instead of `fileName`, and leaves out fields that are `nil`.
- **Supported file types** use the documented `/v3/miscellaneous/supported-plagiarism-file-types` path. The response is the same.
- **Login tokens.** `verify_auth_token` treats a token that expires within 5 minutes as expired, so it cannot expire in the middle of a request.
- **User-Agent** is now `ruby-sdk/5.0.0`.
- **Text Moderation response models** accept the parsed Hash that the client returns, as well as a JSON String.

### Fixed

- **Usage history.** `Copyleaks::API#get_usages_history_csv` now returns the usage history as CSV text (a String). Earlier versions tried to parse the CSV as JSON and always raised `JSON::ParserError`.
- **Concurrent calls.** Calls made at the same time from several threads on one `Copyleaks::API` could fail with `IOError` or `EOFError`, or return another call's response.
- **AI Text Detection no longer prints every response** (`RES: ...`) to standard output.
- **PDF title color.** The second argument of `Copyleaks::SubmissionPdfColors` is now sent as `titles`, the documented name. Earlier versions sent `title`, which the API ignored.
- **Turning on one filter or scanning option no longer turns others off.** Building a `SubmissionFilter` only to set `safeSearch` used to turn off minor-change and related-meaning matching, and building a `SubmissionScanning` only to add a repository used to turn off internet scanning.
- **`Copyleaks::SubmissionProperties` no longer raises** when `developerPayload`, `expiration` or `sensitivityLevel` is left out.
- **Exports of a single artifact**, such as only the PDF report, no longer raise.
- **Special characters in ids.** Scan ids, export ids, repository ids and language codes are percent-encoded in the URL, and the usage history dates are encoded in the query string. An id with a space, `/`, `?`, `#` or `%` no longer breaks the request.
- **`login` checks the `key` argument.** Earlier versions checked `email` twice.
- **Building webhook models from webhook bodies.** `Copyleaks::Results` and `Copyleaks::Error` accept the newer webhook fields instead of raising `ArgumentError`, `Copyleaks::Internet` no longer requires a `scanId`, and `Copyleaks::CopyleaksTextModerationResponseModel.new` and `Copyleaks::TextModerationScannedDocument.new` no longer raise when no creation time is given.

### Upgrade notes

- **Gemfile:** replace `gem 'plagiarism-checker'` with `gem 'copyleaks'`, then run `bundle install`. If you pin a version, use `gem 'copyleaks', '~> 5.0'`.
- **Command line:** `gem install copyleaks`. Then remove the old gem with `gem uninstall plagiarism-checker`.
- **Do not keep both gems.** Both gems ship `lib/copyleaks.rb`, so with both installed, `require 'copyleaks'` can load either one.
- **Your code:** `require 'copyleaks'`, the `Copyleaks` module and all class names stay the same. No code changes are needed for the rename.
- **Webhooks:** existing code that reads `notifications` or builds `Copyleaks::Alerts` keeps working. If you serialize an `Alerts` object, note that `nil` fields are now left out of the JSON.
- **Defaults of filters and scanning:** `Copyleaks::SubmissionFilter.new` used to send `minorChangesEnabled: false` and `relatedMeaningEnabled: false`, and `Copyleaks::SubmissionScanning.new` used to send `internet: false`. These fields are now left out, and the API default (`true`) applies. To keep them off, pass `false`, for example `Copyleaks::SubmissionFilter.new(true, false, false)` or `Copyleaks::SubmissionScanning.new(false)`.
- **Timeouts and retries:** a response that takes more than 120 seconds now raises `Net::ReadTimeout`; pass a larger `read_timeout:` to `Copyleaks::API.new` if you need one. Requests are no longer resent after a timeout or a dropped connection. If a submit raises a timeout, the scan may have been created: submitting again with the same scan id returns `409 Conflict`.
- **Text Moderation:** more than 16 labels raises `ArgumentError`. The API rejects such requests anyway.
- **AI Image Detection:** `CopyleaksAiImageDetectionRequestModel#to_hash` now uses the key `filename` (was `fileName`) and leaves out `nil` fields. A `sandbox` that is not `true`, `false` or `nil` raises `ArgumentError`.
- **Delete requests:** `Copyleaks::CopyleaksDeleteRequestModel#completionWebhook` returns `nil` (was `''`) when no webhook is set, and `purge` is sent only when you set it.
- **Login tokens:** `verify_auth_token`, and every call that checks the token, raises `Copyleaks::AuthExpiredException` 5 minutes before the token's expiry time. Log in again when it does.
- **Stricter types:** `Copyleaks::SubmissionScanning` raises when `internet` is not `true`, `false` or `nil`.
- **Sub-clients:** if you build `AIDetectionClient`, `AIImageDetectionClient`, `TextModerationClient` or `WritingAssistantClient` yourself, they now use a `Copyleaks::HttpClient`. A `Net::HTTP` object is still accepted. Using `api.ai_detection_client` and the other accessors needs no change.
