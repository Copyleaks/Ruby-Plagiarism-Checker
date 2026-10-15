module Copyleaks
  # Where Copyleaks uploads one exported artifact: an HTTP endpoint, a verb and optional headers.
  class ExportTarget
    attr_reader :endpoint, :verb, :headers

    # @param [String] verb For example 'POST'.
    # @param [Array<Array<String>>] headers Extra upload request headers, e.g. [['Authorization', 'Bearer my-token']].
    def initialize(endpoint, verb, headers = nil)
      raise "Copyleaks::#{self.class.name.split('::').last} - endpoint - endpoint must be of type String" unless endpoint.instance_of?(String)
      raise "Copyleaks::#{self.class.name.split('::').last} - verb - verb must be of type String" unless verb.instance_of?(String)
      unless headers.nil? || (headers.instance_of?(Array) && headers.all? { |pair| pair.instance_of?(Array) && pair.length == 2 && pair.all? { |part| part.instance_of?(String) } })
        raise "Copyleaks::#{self.class.name.split('::').last} - headers - headers must be an Array of String Array pairs"
      end

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

  # Export the AI Content Detection report. Allowed only when properties.aiGeneratedText.detect was true on the scan.
  class ExportAiDetection < ExportTarget; end

  # Export the Grammar Checker report. Allowed only when properties.writingFeedback.enable was true on the scan.
  class ExportWritingFeedback < ExportTarget; end

  # Export the Gen-AI Overview report. Allowed only when properties.overview.enable was true on the scan.
  class ExportOverview < ExportTarget; end
end
