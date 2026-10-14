require 'json'

module Copyleaks
  class TextModerationChars
    attr_accessor :labels, :starts, :lengths

    def initialize(starts: [], labels: [], lengths: [])
      @starts = starts
      @labels = labels
      @lengths = lengths
    end

    def to_json(options = {})
      {
        labels: @labels,
        starts: @starts,
        lengths: @lengths
      }.to_json(options)
    end

    # @param json [Hash, String] A parsed Hash or a JSON String.
    def self.from_json(json)
      data = TextModerationJson.to_hash(json)
      return nil if data.nil?

      new(
        labels: TextModerationJson.get(data, 'labels'),
        starts: TextModerationJson.get(data, 'starts'),
        lengths: TextModerationJson.get(data, 'lengths')
      )
    end
  end
end
