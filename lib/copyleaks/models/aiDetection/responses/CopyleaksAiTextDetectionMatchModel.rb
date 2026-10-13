# frozen_string_literal: true

# ********************************************************************************
# The MIT License(MIT)
#
# Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ********************************************************************************

module Copyleaks
  # The positions of a classified part of the text.
  class CopyleaksAiTextDetectionMatchModel
    # Positions in the text version of the document.
    attr_accessor :text

    # Positions in the HTML version of the document. Present only for HTML sources.
    attr_accessor :html

    # Initialize a new CopyleaksAiTextDetectionMatchModel
    #
    # @param text [CopyleaksAiTextDetectionMatchTextModel] Positions in the text version of the document
    # @param html [CopyleaksAiTextDetectionMatchTextModel] Positions in the HTML version of the document (HTML sources only)
    def initialize(text: nil, html: nil)
      @text = text
      @html = html
    end

    # Create instance from JSON hash
    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      text = CopyleaksAiTextDetectionMatchTextModel.from_json(json_hash['text']) if json_hash['text']
      html = CopyleaksAiTextDetectionMatchTextModel.from_json(json_hash['html']) if json_hash['html']

      new(text: text, html: html)
    end

    # Convert to JSON
    def to_json(*args)
      {
        'text' => @text,
        'html' => @html
      }.compact.to_json(*args)
    end
  end
end
