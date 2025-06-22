require 'json'
module Copyleaks

class TextModerationChars
  attr_accessor :labels, :starts, :lengths

  def initialize(labels: [], starts: [], lengths: [])
    @labels = labels
    @starts = starts
    @lengths = lengths
  end


  def to_json(options = {})
    {
      labels: @labels,
      starts: @starts,
      lengths: @lengths
    }.to_json(options)
  end

  def self.from_json(json_string)
    data = JSON.parse(json_string, symbolize_names: true)
    new(
      labels: data[:labels],
      starts: data[:starts],
      lengths: data[:lengths]
    )
  end
end

end
