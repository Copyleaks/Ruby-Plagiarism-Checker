require 'json'

module Copyleaks
  class CopyleaksTextModerationRequestModel
    attr_accessor :text, :sandbox, :language, :labels

    # @param text [String] Text to produce Text Moderation report for.
    # @param sandbox [Boolean] Use sandbox mode to test your integration. Default: false.
    # @param language [String, nil] The language code. Optional; set to nil for auto-detect.
    # @param labels [Array<Object>] A list of label configurations (min 1, max 32 elements).
    def initialize(text: '', sandbox: false, language: nil, labels: [])
      
      raise ArgumentError, "String cannot be blank" if @text.nil?
      raise ArgumentError, "Labels must be a non-empty array." unless labels.is_a?(Array) && !labels.empty?
      raise ArgumentError, "Labels cannot have more than 32 elements." if labels.length > 32
      
      @text = text
      @sandbox = sandbox
      @language = language
      @labels = labels

    end

    def to_json(options = {})
      {
        text: @text,
        sandbox: @sandbox,
        language: @language,
        labels: @labels
      }.to_json(options)
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
