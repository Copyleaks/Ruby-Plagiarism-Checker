#
#  The MIT License(MIT)
#
#  Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
# =
require 'json'

module Copyleaks
  class CopyleaksTextModerationRequestModel
    attr_accessor :text, :sandbox, :language, :labels

    # @param text [String] Text to produce Text Moderation report for.
    # @param sandbox [Boolean] Use sandbox mode to test your integration. Default: false.
    # @param language [String, nil] The language code. Optional; set to nil for auto-detect.
    # @param labels [Array<Object>] A list of label configurations (min 1, max 32 elements).
    def initialize(text: '', sandbox: false, language: nil, labels: [])

      @text = text
      @sandbox = sandbox
      @language = language
      @labels = labels

      raise ArgumentError, "String cannot be blank" if @text.nil?
      raise ArgumentError, "Labels must be a non-empty array." unless labels.is_a?(Array) && !labels.empty?
      raise ArgumentError, "Labels cannot have more than 32 elements." if labels.length > 32

    end

    def to_json(options = {})
      {
        text: @text,
        sandbox: @sandbox,
        language: @language,
        labels: @labels
      }.to_json(options)
    end

    def self.from_json(json_string)
      data = JSON.parse(json_string, symbolize_names: true)
      new(
        text: data[:text],
        sandbox: data[:sandbox],
        language: data[:language],
        labels: data[:labels]
      )
    end
  end
end
