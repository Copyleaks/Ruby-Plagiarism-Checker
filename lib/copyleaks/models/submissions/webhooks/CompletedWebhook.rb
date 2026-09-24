 #The MIT License(MIT)
 #Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
 #Permission is hereby granted, free of charge, to any person obtaining a copy
 #of this software and associated documentation files (the "Software"), to deal
 #in the Software without restriction, including without limitation the rights
 #to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 #copies of the Software, and to permit persons to whom the Software is
 #furnished to do so, subject to the following conditions:
 #The above copyright notice and this permission notice shall be included in all
 #copies or substantial portions of the Software.
 #THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 #IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 #FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
 #AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 #LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 #OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 #SOFTWARE.
 #=

module Copyleaks
  class CompletedWebhook < StatusWebhook
    attr_reader :results, :notifications, :scannedDocument

    def initialize(results: nil, notifications: nil, scannedDocument: nil, **args)
      super(**args)
      @results = results
      @notifications = notifications
      @scannedDocument = scannedDocument
      @extra_fields = args # Store any additional fields here
    end

    # Finds the AI text detection alert of this scan.
    #
    # Works whether notifications is the raw Hash from the webhook body (string or symbol keys)
    # or a Copyleaks::Notifications object.
    # A nil result means the scan produced no 'suspected-ai-text' alert. It does not by itself prove
    # that AI detection ran: check the scan's aiGeneratedText.detect setting and the category 2
    # failure codes in Copyleaks::CopyleaksAlertCodes (for example AI_DETECTION_FAILED).
    #
    # @return [Alerts, nil] The first alert whose code is Copyleaks::CopyleaksAlertCodes::SUSPECTED_AI_TEXT, or nil.
    def ai_detection_alert
      alerts = notification_alerts
      return nil unless alerts.is_a?(Array)

      alerts.each do |alert|
        if alert.is_a?(Alerts)
          return alert if alert.code == CopyleaksAlertCodes::SUSPECTED_AI_TEXT
        elsif alert.is_a?(Hash)
          code = alert.key?('code') ? alert['code'] : alert[:code]
          return Alerts.from_json(alert) if code == CopyleaksAlertCodes::SUSPECTED_AI_TEXT
        end
      end
      nil
    end

    # Decodes the AI text detection result of the 'suspected-ai-text' alert of this scan.
    #
    # A nil result means the scan produced no 'suspected-ai-text' alert, or the alert has no data.
    # It does not by itself prove that AI detection ran: check the scan's aiGeneratedText.detect
    # setting and the category 2 failure codes in Copyleaks::CopyleaksAlertCodes.
    #
    # @return [CopyleaksAiTextDetectionResponseModel, nil] The decoded result, or nil.
    # @raise [JSON::ParserError] When the alert's additionalData is not valid JSON.
    def ai_detection_result
      alert = ai_detection_alert
      alert.nil? ? nil : alert.ai_detection_result
    end

    def as_json(*_args)
      super.merge(
        {
          results: @results.respond_to?(:as_json) ? @results.as_json : @results,
          notifications: @notifications.respond_to?(:as_json) ? @notifications.as_json : @notifications,
          scannedDocument: @scannedDocument.respond_to?(:as_json) ? @scannedDocument.as_json : @scannedDocument
        }
      ).merge(@extra_fields)
    end

    def to_json(*options)
      as_json.to_json(*options)
    end

    private

    # @return [Array, nil] The alerts of the notifications section, as received or as Alerts objects.
    def notification_alerts
      if @notifications.is_a?(Hash)
        @notifications.key?('alerts') ? @notifications['alerts'] : @notifications[:alerts]
      elsif @notifications.respond_to?(:alerts)
        @notifications.alerts
      end
    end
  end
end