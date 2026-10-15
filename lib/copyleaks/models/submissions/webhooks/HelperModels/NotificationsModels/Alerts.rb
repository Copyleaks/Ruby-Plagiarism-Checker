require 'json'

module Copyleaks
  class Alerts
    attr_reader :category, :code, :title, :message, :helpLink, :severity, :additionalData

    # The wire fields of a scan alert, used by Alerts.from_json.
    FIELDS = %i[category code title message helpLink severity additionalData].freeze

    # Bytes removed from the end of additionalData before it is parsed: NUL, tab, LF, VT, FF, CR and space.
    TRAILING_BYTES = [0x00, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x20].freeze
    private_constant :FIELDS, :TRAILING_BYTES

    # category and severity (0-4) are Integers; Strings are also accepted for backward compatibility.
    # @param [String] code Unique per alert type; see Copyleaks::CopyleaksAlertCodes.
    # @param [String, nil] additionalData Extra data about the alert, as a JSON string.
    def initialize(category:, code:, severity:, title: nil, message: nil, helpLink: nil, additionalData: nil)
      raise 'Copyleaks::Alerts - category must be an Integer or a String' unless integer_or_string?(category)
      raise 'Copyleaks::Alerts - code must be a String' unless code.is_a?(String)
      raise 'Copyleaks::Alerts - title must be a String' unless title.nil? || title.is_a?(String)
      raise 'Copyleaks::Alerts - message must be a String' unless message.nil? || message.is_a?(String)
      raise 'Copyleaks::Alerts - helpLink must be a String' unless helpLink.nil? || helpLink.is_a?(String)
      raise 'Copyleaks::Alerts - severity must be an Integer or a String' unless integer_or_string?(severity)
      raise 'Copyleaks::Alerts - additionalData must be a String' unless additionalData.nil? || additionalData.is_a?(String)

      @category = category
      @code = code
      @title = title
      @message = message
      @helpLink = helpLink
      @severity = severity
      @additionalData = additionalData
    end

    # Builds an alert from an item of JSON.parse(body)['notifications']['alerts'] (String or Symbol keys,
    # unknown keys ignored). Returns nil for nil.
    # @raise [ArgumentError] When category, code or severity is missing.
    # @raise [RuntimeError] When a field has the wrong type.
    def self.from_json(json_hash)
      return nil if json_hash.nil?

      args = {}
      json_hash.each do |key, value|
        name = key.to_sym
        args[name] = value if FIELDS.include?(name)
      end
      new(**args)
    end

    # Decodes the AI text detection result that only the 'suspected-ai-text' alert carries, as a JSON string in
    # additionalData. Trailing NUL and ASCII whitespace are removed first; additionalData itself stays raw.
    # @return [CopyleaksAiTextDetectionResponseModel, nil] nil for other alerts, missing data or a non-object.
    # @raise [JSON::ParserError] When additionalData is not valid JSON.
    def ai_detection_result
      return nil unless @code == CopyleaksAlertCodes::SUSPECTED_AI_TEXT
      return nil if @additionalData.nil?

      data = @additionalData
      length = data.bytesize
      # Linear scan from the end. NUL and ASCII whitespace are single bytes in UTF-8,
      # so they never match inside a multi-byte character.
      length -= 1 while length > 0 && TRAILING_BYTES.include?(data.getbyte(length - 1))
      return nil if length.zero?

      CopyleaksAiTextDetectionResponseModel.from_json(JSON.parse(data.byteslice(0, length)))
    end

    def as_json(*_args)
      {
        category: @category,
        code: @code,
        title: @title,
        message: @message,
        helpLink: @helpLink,
        severity: @severity,
        additionalData: @additionalData
      }.compact
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    private

    # True for an Integer (the wire form) or a String (accepted by earlier versions).
    def integer_or_string?(value)
      value.is_a?(Integer) || value.is_a?(String)
    end
  end
end