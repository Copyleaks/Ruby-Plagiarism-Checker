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

  def self.from_json(json_string)
    data = JSON.parse(json_string, symbolize_names: true)
    new(
      index: data[:index],
      id: data[:id]
    )
  end
end
end
