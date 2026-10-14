#
#  The MIT License(MIT)
#
#  Copyright(c) 2023 Copyleaks LTD (https://copyleaks.com)
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
  class SubmissionAiGeneratedText
    attr_reader :detect, :sensitivity, :explain

    # Every field is optional. A field left nil is not sent, and the server default applies.
    # @param [Boolean] detect Detects whether the text was written by an AI (server default: false).
    # @param [Integer] sensitivity How aggressive the AI detection is, 1 to 3 (server default: 2).
    #   1 finds text copied from an AI tool without edits, 3 also finds heavily edited AI text.
    # @param [SubmissionAiGeneratedTextExplain, Boolean] explain AI Logic: return explanations with the
    #   AI detection result. true is the same as SubmissionAiGeneratedTextExplain.new(true).
    def initialize(detect = nil, sensitivity: nil, explain: nil)
      if !detect.nil? && ![true, false].include?(detect)
        raise 'Copyleaks::SubmissionAiGeneratedText - detect - detect must be of type Boolean'
      end
      if !sensitivity.nil? && !(sensitivity.is_a?(Integer) && sensitivity.between?(1, 3))
        raise 'Copyleaks::SubmissionAiGeneratedText - sensitivity - sensitivity must be an Integer from 1 to 3'
      end

      explain = SubmissionAiGeneratedTextExplain.new(explain) if [true, false].include?(explain)
      if !explain.nil? && !explain.instance_of?(SubmissionAiGeneratedTextExplain)
        raise 'Copyleaks::SubmissionAiGeneratedText - explain - explain must be of type SubmissionAiGeneratedTextExplain'
      end

      @detect = detect
      @sensitivity = sensitivity
      @explain = explain
    end

    def as_json(*_args)
      {
        detect: @detect,
        sensitivity: @sensitivity,
        explain: @explain
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
