require 'json'

module Copyleaks
  class CopyleaksTextModerationRequestModel
    attr_accessor :text, :sandbox, :language, :labels

    def initialize(text: '', sandbox: false, language: nil, labels: [])
      @text = text
      @sandbox = sandbox
      @language = language
      @labels = labels

      raise ArgumentError, "String cannot be blank" if @text.blank?
      # Validate the labels
      raise ArgumentError, "Labels array must have at least 1 element" if @labels.empty?
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