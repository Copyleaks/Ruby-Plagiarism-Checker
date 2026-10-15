module Copyleaks
  class Error
    attr_reader :code, :message, :type, :id, :url, :details

    # Every field is optional, so an error webhook from any API version can be loaded.
    # @param [String] type For example 'invalid_request_error' or 'payment_error'.
    # @param [String] id Machine-readable, for example 'insufficient_credits'.
    # @param [String] url Documentation page for this error.
    # @param [Array<Hash>] details The parameters that caused the error, each with param and message.
    def initialize(code: nil, message: nil, type: nil, id: nil, url: nil, details: nil, **_extra)
      raise 'Copyleaks::Error - code must be an Integer' unless code.nil? || code.is_a?(Integer)
      raise 'Copyleaks::Error - message must be a String' unless message.nil? || message.is_a?(String)
      raise 'Copyleaks::Error - type must be a String' unless type.nil? || type.is_a?(String)
      raise 'Copyleaks::Error - id must be a String' unless id.nil? || id.is_a?(String)
      raise 'Copyleaks::Error - url must be a String' unless url.nil? || url.is_a?(String)
      raise 'Copyleaks::Error - details must be an Array' unless details.nil? || details.is_a?(Array)

      @code = code
      @message = message
      @type = type
      @id = id
      @url = url
      @details = details
    end

    # json_hash is the 'error' object of a parsed webhook body (String or Symbol keys). nil for a non-Hash.
    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(**json_hash.transform_keys(&:to_sym))
    end

    def as_json(*_args)
      hash = {
        code: @code,
        message: @message
      }
      hash[:type] = @type unless @type.nil?
      hash[:id] = @id unless @id.nil?
      hash[:url] = @url unless @url.nil?
      hash[:details] = @details unless @details.nil?
      hash
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
