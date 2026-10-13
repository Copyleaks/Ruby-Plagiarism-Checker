# Changelog

All notable changes to the Copyleaks Ruby SDK are listed here.

## 5.0.0

The gem is now published as `copyleaks`. Versions up to 4.1.1 were published as `plagiarism-checker`. The Ruby code you write does not change: `require 'copyleaks'` and the `Copyleaks` module are the same as before. Read the upgrade notes below.

### Added

- **New submit properties (BAC-5378).**
  - `Copyleaks::SubmissionAiSourceMatch.new(true)`, passed as the new `aiSourceMatch` argument of `Copyleaks::SubmissionProperties`: finds online sources suspected of containing AI-generated text. It currently applies only to documents detected as English. When you leave it `nil`, the server default (disabled) applies.
  - `displayLanguage` argument of `Copyleaks::SubmissionProperties`: the language of the scan's PDF report. One of `'en'`, `'es'`, `'pt'`, `'fr'`, `'de'`, `'it'` (lowercase, case-sensitive). The server default is `'en'`.
  - `reportVersion` argument of `Copyleaks::SubmissionPDF`: which version of the PDF report to generate. One of `'v1'`, `'v2'`, `'v3'`, `'latest'` (lowercase, case-sensitive). It overrides `version` when both are set.
  - The new arguments come after the existing ones and default to `nil`, so existing calls keep working. A value of the wrong type raises an error. A `nil` value is left out of the request.
- **AI alert in the completed webhook (BAC-5392).**
  - `Copyleaks::CompletedWebhook#ai_detection_alert` returns the `suspected-ai-text` alert as a `Copyleaks::Alerts`, or `nil` when the scan has no AI alert. It works whether `notifications` is the raw Hash from the webhook body or a `Copyleaks::Notifications` object. A malformed AI alert raises: `ArgumentError` when `severity` or `category` is missing, or `RuntimeError` when a field has the wrong type. The API always sends both fields.
  - `Copyleaks::Alerts#ai_detection_result` and the shortcut `Copyleaks::CompletedWebhook#ai_detection_result` decode the alert's `additionalData` JSON string into a `Copyleaks::CopyleaksAiTextDetectionResponseModel`, with `summary.ai`, `summary.human`, `model_version`, `results`, `translation` and `explain`. They return `nil` when there is no AI alert, or when the data is empty or is JSON that is not an object. They raise `JSON::ParserError` when `additionalData` is not valid JSON. The raw string stays available as `alert.additionalData`.
  - `Copyleaks::Alerts.from_json(hash)` builds an alert from a webhook alert Hash with String or Symbol keys.
  - New constant `Copyleaks::CopyleaksAlertCodes::SUSPECTED_AI_TEXT` (`"suspected-ai-text"`).
  - New AI Text Detection model classes, loaded by `require 'copyleaks'`.

### Changed

- **Gem renamed to `copyleaks` (BAC-5374).** The gemspec is now `copyleaks.gemspec`, and the gem summary and description describe the Copyleaks platform.
- **The gem no longer installs the `console` and `setup` executables (BAC-5374).** These are development scripts from the repository's `bin/` folder, and 4.x installed them as commands.
- **`Copyleaks::Alerts` accepts the webhook's own types (BAC-5392).** `category` and `severity` can be Integers, as the webhook sends them. Strings are still accepted. `title`, `message`, `helpLink` and `additionalData` are now optional. `to_json` leaves out fields that are `nil`.
- **README (BAC-5374).** The README now describes the SDK as the Copyleaks platform SDK and lists the products it covers: AI Text Detection, AI Image Detection, Plagiarism Checker, Grammar Checker and Text Moderation. Headings such as "AI Text Detection" now use the product names.

### Fixed

- **Usage history (BAC-6741).** `Copyleaks::API#get_usages_history_csv` now returns the usage history as CSV text (a String). Earlier versions tried to parse the CSV as JSON and always raised `JSON::ParserError`.

### Upgrade notes

- **Gemfile:** replace `gem 'plagiarism-checker'` with `gem 'copyleaks'`, then run `bundle install`. If you pin a version, use `gem 'copyleaks', '~> 5.0'`.
- **Command line:** `gem install copyleaks`. Then remove the old gem with `gem uninstall plagiarism-checker`.
- **Do not keep both gems.** Both gems ship `lib/copyleaks.rb`, so with both installed, `require 'copyleaks'` can load either one.
- **Your code:** `require 'copyleaks'`, the `Copyleaks` module and all class names stay the same. No code changes are needed for the rename.
- **Webhooks:** existing code that reads `notifications` or builds `Copyleaks::Alerts` keeps working. If you serialize an `Alerts` object, note that `nil` fields are now left out of the JSON.
