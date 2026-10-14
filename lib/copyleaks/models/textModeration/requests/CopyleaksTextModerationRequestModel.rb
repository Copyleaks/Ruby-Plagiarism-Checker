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
    # The server accepts at most this many labels per request.
    MAX_LABELS = 16

    attr_accessor :text, :sandbox, :language, :labels

    # @param text [String] Text to produce Text Moderation report for.
    # @param sandbox [Boolean, nil] Use sandbox mode to test your integration. Leave nil to omit it (server default: false).
    # @param language [String, nil] The language code. Optional; leave nil for auto-detect.
    # @param labels [Array<CopyleaksTextModerationLabel>] The labels to check (required, 1 to 16 labels).
    def initialize(text: '', sandbox: nil, language: nil, labels: [])

      @text = text
      @sandbox = sandbox
      @language = language
      @labels = labels

      raise ArgumentError, "String cannot be blank" if @text.nil?
      raise ArgumentError, "Labels must be a non-empty array." unless labels.is_a?(Array) && !labels.empty?
      raise ArgumentError, "Labels cannot have more than #{MAX_LABELS} elements." if labels.length > MAX_LABELS

    end

    def to_json(options = {})
      {
        text: @text,
        sandbox: @sandbox,
        language: @language,
        labels: @labels
      }.reject { |_k, v| v.nil? }.to_json(options)
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
