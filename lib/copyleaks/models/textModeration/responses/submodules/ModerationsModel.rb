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

 
  def self.from_json(json_string)
    data = JSON.parse(json_string, symbolize_names: true)
    new(
      text: data[:text] ? Text.from_json(data[:text].to_json) : nil
    )
  end
end
end