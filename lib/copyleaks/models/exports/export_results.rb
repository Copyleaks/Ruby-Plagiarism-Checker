module Copyleaks
  class ExportResults
    attr_reader :id, :endpoint, :verb, :headers

    # @param [String] id Result id, from the completed webhook. The other arguments are as in ExportTarget.
    def initialize(id, endpoint, verb, headers = nil)
      raise 'Copyleaks::ExportResults - id - id must be of type String' unless id.instance_of?(String)
      raise 'Copyleaks::ExportResults - endpoint - endpoint must be of type String' unless endpoint.instance_of?(String)
      raise 'Copyleaks::ExportResults - verb - verb must be of type String' unless verb.instance_of?(String)

      @id = id
      @endpoint = endpoint
      @verb = verb
      @headers = headers
    end

    def as_json(*_args)
      {
        id: @id,
        endpoint: @endpoint,
        verb: @verb,
        headers: @headers
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
