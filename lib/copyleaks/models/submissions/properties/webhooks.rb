module Copyleaks
  class SubmissionWebhooks
    # See https://docs.copyleaks.com/reference/data-types/authenticity/webhooks/overview
    # @param [String] status Called when the scan status changes. The {STATUS} token in the URL is replaced with
    #   completed, error, creditschecked or indexed.
    # @param [String] newResult Called for each new result while the scan runs, so a live report can load gradually.
    # @param [Array] statusHeaders Headers added to the status webhook.
    # @param [Array] newResultHeaders Headers added to the new result webhook.
    def initialize(status, newResult = nil, statusHeaders = nil, newResultHeaders = nil)
      unless status.instance_of? String
        raise 'Copyleaks::SubmissionWebhooks - status - status must be of type String'
      end
      unless newResult.nil? || newResult.instance_of?(String)
        raise 'Copyleaks::SubmissionWebhooks - newResult - newResult must be of type String'
      end
      unless header_format_valid?(statusHeaders)
        raise 'Copyleaks::SubmissionWebhooks - statusHeaders - statusHeaders must be an Array of String Array pairs'
      end
      unless header_format_valid?(newResultHeaders)
        raise 'Copyleaks::SubmissionWebhooks - newResultHeaders - newResultHeaders must be an Array of String Array pairs'
      end

      @newResult = newResult
      @status = status
      @statusHeaders = statusHeaders
      @newResultHeaders = newResultHeaders
    end

    def as_json(*_args)
      {
        newResult: @newResult,
        status: @status,
        statusHeaders: @statusHeaders,
        newResultHeaders: @newResultHeaders
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    private

    def header_format_valid?(header)
      return true if header.nil?
      return false unless header.instance_of?(Array)

      header.all? do |pair|
        pair.instance_of?(Array) && pair.length == 2 && pair[0].instance_of?(String) && pair[1].instance_of?(String)
      end
    end
  end
end
