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
  class SubmissionExclude
    # @param [Boolean] quotes Exclude quoted text from the scan.
    # @param [Boolean] references Exclude referenced text from the scan.
    # @param [Boolean] tableOfContents Exclude table of contents from the scan.
    # @param [Boolean] titles Exclude titles from the scan.
    # @param [Boolean] htmlTemplate When the scanned document is an HTML document, exclude irrelevant text that appears across the site like the website footer or header.
    # @param [Boolean] citations - Exclude citations from the scan.
    # @param [String[]] documentTemplateIds - Exclude text based on text found within other documents.
    # @param [SubmissionExcludeCode] code - Exclude sections of source code

    def initialize(
      quotes = false,
      references = false,
      tableOfContents = false,
      titles = false,
      htmlTemplate = false,
      citations = nil,
      documentTemplateIds = nil,
      code = nil
    )
      if !citations.nil? && ![true, false].include?(citations)
        raise 'Copyleaks::SubmissionExclude - citations - citations must be of type Boolean'
      end

      if !documentTemplateIds.nil? && !(documentTemplateIds.is_a?(Array) && documentTemplateIds.all? { |element| element.is_a?(String) })
        raise 'Copyleaks::SubmissionExclude - documentTemplateIds - documentTemplateIds must be of type String[]'
      end

      if !code.nil? && !code.instance_of?(SubmissionExcludeCode)
        raise 'Copyleaks::SubmissionExclude - code - code must be of type SubmissionExcludeCode'
      end

      @quotes = quotes
      @references = references
      @tableOfContents = tableOfContents
      @titles = titles
      @htmlTemplate = htmlTemplate
      @citations = citations
      @documentTemplateIds = documentTemplateIds
      @code = code

    end

    def as_json(*_args)
      {
        quotes: @quotes,
        references: @references,
        tableOfContents: @tableOfContents,
        titles: @titles,
        htmlTemplate: @htmlTemplate,
        citations: @citations,
        documentTemplateIds: @documentTemplateIds,
        code: @code
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
