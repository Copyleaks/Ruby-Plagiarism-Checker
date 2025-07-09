require 'json'

module Copyleaks
class Text
  attr_accessor :chars

  # @param chars [TextModerationChars] An object that groups together several arrays detailing the properties of labelled segments.
  def initialize(chars: TextModerationChars.new)
    @chars = chars
  end

  def to_json(options = {})
    {
      chars: @chars ? JSON.parse(@chars.to_json) : nil
    }.to_json(options)
  end


  def self.from_json(json_string)
    data = JSON.parse(json_string, symbolize_names: true)
    new(
      chars: data[:chars] ? TextModerationChars.from_json(data[:chars].to_json) : nil
    )
  end
end
end