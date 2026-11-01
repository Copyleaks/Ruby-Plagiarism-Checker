require 'json'

module Copyleaks
  class CopyleaksTextModerationRequestModel
    # The server accepts at most this many labels per request.
    MAX_LABELS = 16

    attr_accessor :text, :sandbox, :language, :labels

    # @param sandbox [Boolean, nil] Test mode. nil omits the field (server default: false).
    # @param language [String, nil] Language code; auto-detected when nil.
    # @param labels [Array<CopyleaksTextModerationLabel>] Required, 1 to MAX_LABELS labels to check.
    def initialize(text: '', sandbox: nil, language: nil, labels: [])

      @text = text
      @sandbox = sandbox
      @language = language
      @labels = labels

      raise ArgumentError, "String cannot be blank" if @text.nil?
      raise ArgumentError, "Labels must be a non-empty array." unless labels.is_a?(Array) && !labels.empty?
      raise ArgumentError, "Labels cannot have more than #{MAX_LABELS} elements." if labels.length > MAX_LABELS

    end

    def to_json(options = {})
      {
        text: @text,
        sandbox: @sandbox,
        language: @language,
        labels: @labels
      }.reject { |_k, v| v.nil? }.to_json(options)
    end

    def self.from_json(json_string)
      data = JSON.parse(json_string, symbolize_names: true)
      new(
        text: data[:text],
        sandbox: data[:sandbox],
        language: data[:language],
        labels: data[:labels]
      )
    end
  end
end
