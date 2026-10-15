module Copyleaks
  class ExportPdfReport
    attr_reader :endpoint, :verb, :headers

    # Same arguments as ExportTarget.
    def initialize(endpoint, verb, headers = nil)
      unless endpoint.instance_of?(String)
        raise 'Copyleaks::ExportPdfReport - endpoint - endpoint must be of type String'
      end
      raise 'Copyleaks::ExportPdfReport - verb - verb must be of type String' unless verb.instance_of?(String)

      @endpoint = endpoint
      @verb = verb
      @headers = headers
    end

    def as_json(*_args)
      {
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
