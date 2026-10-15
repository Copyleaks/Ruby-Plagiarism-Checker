module Copyleaks
  class SubmissionFilter
    # Arguments left nil are not sent, so the server default applies.
    # @param [Boolean] identicalEnabled Match exact words (server default: true).
    # @param [Boolean] minorChangesEnabled Match nearly identical words, like slow and slowly (server default: true).
    # @param [Boolean] relatedMeaningEnabled Match paraphrased content (server default: true).
    # @param [Integer] minCopiedWords Only results with at least this many copied words.
    # @param [Boolean] safeSearch Block explicit adult content from results; not 100% effective (server default: false).
    # @param [String[]] domains Included or excluded, depending on domainsMode (server default: EXCLUDE).
    # @param [Boolean] allowSameDomain Allow results from the submitted URL's domain (server default: false).
    def initialize(
      identicalEnabled = nil,
      minorChangesEnabled = nil,
      relatedMeaningEnabled = nil,
      minCopiedWords = nil,
      safeSearch = nil,
      domains = nil,
      domainsMode = nil,
      allowSameDomain = nil
    )
      @identicalEnabled = identicalEnabled
      @minorChangesEnabled = minorChangesEnabled
      @relatedMeaningEnabled = relatedMeaningEnabled
      @minCopiedWords = minCopiedWords
      @safeSearch = safeSearch
      @domains = domains
      @domainsMode = domainsMode
      @allowSameDomain = allowSameDomain
    end

    def as_json(*_args)
      {
        identicalEnabled: @identicalEnabled,
        minorChangesEnabled: @minorChangesEnabled,
        relatedMeaningEnabled: @relatedMeaningEnabled,
        minCopiedWords: @minCopiedWords,
        safeSearch: @safeSearch,
        domains: @domains,
        domainsMode: @domainsMode,
        allowSameDomain: @allowSameDomain
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
