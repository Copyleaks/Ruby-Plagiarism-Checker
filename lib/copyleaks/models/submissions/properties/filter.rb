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
  class SubmissionFilter
    # @param [Boolean] identicalEnabled Enable matching of exact words in the text.
    # @param [Boolean] minorChangesEnabled Enable matching of nearly identical words with small differences like slow becomes slowly.
    # @param [Boolean] relatedMeaningEnabled Enable matching of paraphrased content stating similar ideas with different words.
    # @param [Integer] minCopiedWords Select results with at least minCopiedWords copied words.
    # @param [Boolean] safeSearch Block explicit adult content from the scan results such as web pages containing inappropriate images and videos. SafeSearch is not 100% effective with all websites.
    # @param [String[]] domains list of domains to either include or exclude from the scan - depending on the value of domainsMode.
    # @param [SubmissionFilterDomainsMode] domainsMode Include or Exclude the list of domains you specified under the domains property
    # @param [Boolean] allowSameDomain when set to true it will allow results from the same domain as the submitted url.
    def initialize(
      identicalEnabled = true,
      minorChangesEnabled = false,
      relatedMeaningEnabled = false,
      minCopiedWords = nil,
      safeSearch = false,
      domains = [],
      domainsMode = SubmissionFilterDomainsMode::EXCLUDE,
      allowSameDomain = false
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
