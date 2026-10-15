module Copyleaks
  class CompletedWebhook < StatusWebhook
    attr_reader :results, :notifications, :scannedDocument, :referencesValidation

    # @param [Hash] referencesValidation Citation Checker summary. Present when references.validate was enabled.
    def initialize(results: nil, notifications: nil, scannedDocument: nil, referencesValidation: nil, **args)
      super(**args)
      @results = results
      @notifications = notifications
      @scannedDocument = scannedDocument
      @referencesValidation = referencesValidation
      @extra_fields = args # Store any additional fields here
    end

    # The first 'suspected-ai-text' alert of this scan, or nil. notifications may be the raw webhook Hash
    # (String or Symbol keys) or a Copyleaks::Notifications.
    # @raise [ArgumentError, RuntimeError] When the alert lacks category or severity, or a field has the wrong type.
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

    # Decodes the 'suspected-ai-text' alert's result; nil when there is no such alert. See Alerts#ai_detection_result.
    # @return [CopyleaksAiTextDetectionResponseModel, nil]
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
          scannedDocument: @scannedDocument.respond_to?(:as_json) ? @scannedDocument.as_json : @scannedDocument,
          referencesValidation: @referencesValidation
        }.reject { |key, value| key == :referencesValidation && value.nil? }
      ).merge(@extra_fields)
    end

    def to_json(*options)
      as_json.to_json(*options)
    end

    private

    # @return [Array, nil] The notifications alerts, as received or as Alerts objects.
    def notification_alerts
      if @notifications.is_a?(Hash)
        @notifications.key?('alerts') ? @notifications['alerts'] : @notifications[:alerts]
      elsif @notifications.respond_to?(:alerts)
        @notifications.alerts
      end
    end
  end
end