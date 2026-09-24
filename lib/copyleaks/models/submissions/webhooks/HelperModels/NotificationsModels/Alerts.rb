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

require 'json'

module Copyleaks
  class Alerts
    attr_reader :category, :code, :title, :message, :helpLink, :severity, :additionalData

    # The wire fields of a scan alert, used by Alerts.from_json.
    FIELDS = %i[category code title message helpLink severity additionalData].freeze

    # Bytes removed from the end of additionalData before it is parsed: NUL, tab, LF, VT, FF, CR and space.
    TRAILING_BYTES = [0x00, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x20].freeze
    private_constant :FIELDS, :TRAILING_BYTES

     # @param [int] $category - Scan alert category. An Integer, or a numeric String (kept for backward compatibility).
     # @param [string] $title - Scan alert human-readable title.
     # @param [string] $message - Provides human-readable information about the scan alert.
     # @param [string|null] $helpLink - URL to a resource describing the specific scan alert. Optional.
     # @param [int] $severity - Specifies the importance of the scan alert (0-4). An Integer, or a numeric String (kept for backward compatibility).
     # @param [string|null] $additionalData - Additional data about the scan alert. Supplied as a JSON string. Optional.
     # @param [string] $code - Scan alert code. The code is unique for each scan alert. See Copyleaks::CopyleaksAlertCodes.
    def initialize(category:, code:, title:, message:, severity:, helpLink: nil, additionalData: nil)
      raise 'Copyleaks::Alerts - category must be an Integer or a numeric String' unless integer_like?(category)
      raise 'Copyleaks::Alerts - code must be a String' unless code.is_a?(String)
      raise 'Copyleaks::Alerts - title must be a String' unless title.is_a?(String)
      raise 'Copyleaks::Alerts - message must be a String' unless message.is_a?(String)
      raise 'Copyleaks::Alerts - helpLink must be a String' unless helpLink.nil? || helpLink.is_a?(String)
      raise 'Copyleaks::Alerts - severity must be an Integer or a numeric String' unless integer_like?(severity)
      raise 'Copyleaks::Alerts - additionalData must be a String' unless additionalData.nil? || additionalData.is_a?(String)

      @category = category
      @code = code
      @title = title
      @message = message
      @helpLink = helpLink
      @severity = severity
      @additionalData = additionalData
    end

    # Builds an alert from a completed-webhook alert Hash, for example an item of
    # JSON.parse(body)['notifications']['alerts'].
    #
    # Keys may be Strings or Symbols. Unknown keys are ignored.
    #
    # @param [Hash, nil] json_hash - The alert as received on the wire.
    # @return [Alerts, nil] The alert, or nil when json_hash is nil.
    def self.from_json(json_hash)
      return nil if json_hash.nil?

      args = {}
      json_hash.each do |key, value|
        name = key.to_sym
        args[name] = value if FIELDS.include?(name)
      end
      new(**args)
    end

    # Decodes the AI text detection result carried by this alert.
    #
    # Only the 'suspected-ai-text' alert (Copyleaks::CopyleaksAlertCodes::SUSPECTED_AI_TEXT) carries it:
    # its additionalData is the AI detection result encoded as a JSON string.
    # Trailing NUL characters and whitespace are removed before parsing.
    # The raw string stays available through additionalData.
    #
    # @return [CopyleaksAiTextDetectionResponseModel, nil] The decoded result, or nil when this is not
    #   the 'suspected-ai-text' alert or its additionalData is missing or empty.
    # @raise [JSON::ParserError] When additionalData is not valid JSON.
    def ai_detection_result
      return nil unless @code == CopyleaksAlertCodes::SUSPECTED_AI_TEXT
      return nil if @additionalData.nil?

      data = @additionalData
      length = data.bytesize
      # Linear scan from the end. NUL and ASCII whitespace are single bytes in UTF-8,
      # so they never match inside a multi-byte character.
      length -= 1 while length > 0 && TRAILING_BYTES.include?(data.getbyte(length - 1))
      return nil if length.zero?

      CopyleaksAiTextDetectionResponseModel.from_json(JSON.parse(data.byteslice(0, length)))
    end

    def as_json(*_args)
      {
        category: @category,
        code: @code,
        title: @title,
        message: @message,
        helpLink: @helpLink,
        severity: @severity,
        additionalData: @additionalData
      }.compact
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    private

    # @param [Object] value - A category or severity value.
    # @return [Boolean] true when value is an Integer or a String of digits.
    def integer_like?(value)
      value.is_a?(Integer) || (value.is_a?(String) && value.match?(/\A\d+\z/))
    end
  end
end