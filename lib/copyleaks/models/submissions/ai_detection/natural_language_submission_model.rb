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

module Copyleaks
  class NaturalLanguageSubmissionModel < AIDetectionSubmissionModel
    attr_accessor :language, :explain, :sensitivity

    # @param [String] text A text string, 255 to 100,000 characters.
    # @param [String] language The language code of your content. The selected language should be on the Supported Languages list above. If the 'language' field is not supplied , our system will automatically detect the language of the content.
    # @param [Boolean] sandbox Use sandbox mode to test your integration with the Copyleaks API for free.
    #   Leave nil to omit the field (server default: false).
    # @param [Boolean] explain Enable AI Logic: the response includes explain, with the patterns behind the
    #   result. Leave nil to omit the field (server default: false).
    # @param [Integer] sensitivity How aggressive the detection is, 1 to 3 (server default: 2).
    #   1 finds text copied from an AI tool without edits, 3 also finds heavily edited AI text.
    def initialize(text, language = nil, sandbox = nil, explain: nil, sensitivity: nil)
      unless text.instance_of?(String)
        raise 'Copyleaks::NaturalLanguageSubmissionModel - text - text must be of type String'
      end
      if !explain.nil? && ![true, false].include?(explain)
        raise 'Copyleaks::NaturalLanguageSubmissionModel - explain - explain must be of type Boolean'
      end
      if !sensitivity.nil? && !(sensitivity.is_a?(Integer) && sensitivity.between?(1, 3))
        raise 'Copyleaks::NaturalLanguageSubmissionModel - sensitivity - sensitivity must be an Integer from 1 to 3'
      end
      super(text, sandbox)
      @language = language
      @explain = explain
      @sensitivity = sensitivity
    end

    def as_json(*_args)
      {
        text: @text,
        sandbox: @sandbox,
        language: @language,
        explain: @explain,
        sensitivity: @sensitivity
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
