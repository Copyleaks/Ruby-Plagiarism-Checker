require 'json'
module Copyleaks

class TextModerationChars
  attr_accessor :labels, :starts, :lengths

  # @param starts [Array<Integer>] Start character position of the labelled segment.
  # @param labels [Array<Integer>] Predicted label index for the corresponding segment. The index can be resolved to its ID using the supplied legend.
  # @param lengths [Array<Integer>] Labelled segment character length.
  def initialize( starts: [],labels: [], lengths: [])
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
