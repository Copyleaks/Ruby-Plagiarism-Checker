 #The MIT License(MIT)
 #Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
 #Permission is hereby granted, free of charge, to any person obtaining a copy
 #of this software and associated documentation files (the "Software"), to deal
 #in the Software without restriction, including without limitation the rights
 #to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 #copies of the Software, and to permit persons to whom the Software is
 #furnished to do so, subject to the following conditions:
 #The above copyright notice and this permission notice shall be included in all
 #copies or substantial portions of the Software.
 #THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 #IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 #FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
 #AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 #LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 #OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 #SOFTWARE.
 #=


module Copyleaks
  class Error
    attr_reader :code, :message, :type, :id, :url, :details

    # Every field is optional, so an error webhook from any API version can be loaded.
    # @param [Integer] code - Error code that represents the reason for failure.
    # @param [String] message - Error message that represents the reason for failure.
    # @param [String] type - The error type, for example 'invalid_request_error' or 'payment_error'.
    # @param [String] id - The machine-readable error identifier, for example 'insufficient_credits'.
    # @param [String] url - A URL to the documentation page for this error.
    # @param [Array<Hash>] details - The parameters that caused the error, each with param and message.
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
