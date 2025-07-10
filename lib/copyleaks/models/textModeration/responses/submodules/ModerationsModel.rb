require 'json'
module Copyleaks

class ModerationsModel
  attr_accessor :text

  # @param text [Text] Moderated text segments corresponding to the submitted text. Each position in the inner arrays corresponds to a single segment in the textual version.
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
