require 'json'
module Copyleaks

  class CopyleaksTextModerationLabel
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def to_json(*_args)
      { 'id' => @id }.to_json
    end

    # json is a JSON String or a Hash.
    def self.from_json(json)
      data = json.is_a?(String) ? JSON.parse(json) : json
      new(data['id'] || data[:id])
    end
  end
end