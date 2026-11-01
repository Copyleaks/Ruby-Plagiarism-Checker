require 'json'

module Copyleaks
  class TextModerationsLegend
    attr_accessor :index, :id

    def initialize(index: 0, id: '')
      @index = index
      @id = id
    end

    def to_json(options = {})
      {
        index: @index,
        id: @id
      }.to_json(options)
    end

    def self.from_json(json)
      data = TextModerationJson.to_hash(json)
      return nil if data.nil?

      new(
        index: TextModerationJson.get(data, 'index'),
        id: TextModerationJson.get(data, 'id')
      )
    end
  end
end
