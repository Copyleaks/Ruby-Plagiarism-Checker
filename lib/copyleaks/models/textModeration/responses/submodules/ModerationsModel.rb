require 'json'

module Copyleaks
  class ModerationsModel
    attr_accessor :text

    def initialize(text: Text.new)
      @text = text
    end

    def to_json(options = {})
      {
        text: @text ? JSON.parse(@text.to_json) : nil
      }.to_json(options)
    end

    # @param json [Hash, String] A parsed Hash or a JSON String.
    def self.from_json(json)
      data = TextModerationJson.to_hash(json)
      return nil if data.nil?

      text = TextModerationJson.get(data, 'text')
      new(
        text: text ? Text.from_json(text) : nil
      )
    end
  end
end
