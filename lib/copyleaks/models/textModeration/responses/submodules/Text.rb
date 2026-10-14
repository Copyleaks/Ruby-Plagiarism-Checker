require 'json'

module Copyleaks
  class Text
    attr_accessor :chars

    def initialize(chars: TextModerationChars.new)
      @chars = chars
    end

    def to_json(options = {})
      {
        chars: @chars ? JSON.parse(@chars.to_json) : nil
      }.to_json(options)
    end

    # @param json [Hash, String] A parsed Hash or a JSON String.
    def self.from_json(json)
      data = TextModerationJson.to_hash(json)
      return nil if data.nil?

      chars = TextModerationJson.get(data, 'chars')
      new(
        chars: chars ? TextModerationChars.from_json(chars) : nil
      )
    end
  end
end
