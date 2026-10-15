module Copyleaks
  class SubmissionExclude
    # Arguments left nil are not sent, so the server default (false) applies.
    # @param [Boolean] htmlTemplate For HTML documents, exclude text repeated across the site, like headers and footers.
    # @param [String[]] documentTemplateIds Exclude text found in these other documents.
    # @param [SubmissionExcludeCode] code Not part of the current API reference; kept for compatibility.
    def initialize(
      quotes = nil,
      references = nil,
      tableOfContents = nil,
      titles = nil,
      htmlTemplate = nil,
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
