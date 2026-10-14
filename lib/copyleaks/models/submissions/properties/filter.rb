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
    # Every argument is optional. An argument left nil is not sent, and the server default applies.
    # @param [Boolean] identicalEnabled Enable matching of exact words in the text (server default: true).
    # @param [Boolean] minorChangesEnabled Enable matching of nearly identical words with small differences like slow becomes slowly (server default: true).
    # @param [Boolean] relatedMeaningEnabled Enable matching of paraphrased content stating similar ideas with different words (server default: true).
    # @param [Integer] minCopiedWords Select results with at least minCopiedWords copied words.
    # @param [Boolean] safeSearch Block explicit adult content from the scan results such as web pages containing inappropriate images and videos. SafeSearch is not 100% effective with all websites (server default: false).
    # @param [String[]] domains list of domains to either include or exclude from the scan - depending on the value of domainsMode.
    # @param [SubmissionFilterDomainsMode] domainsMode Include or Exclude the list of domains you specified under the domains property (server default: EXCLUDE).
    # @param [Boolean] allowSameDomain when set to true it will allow results from the same domain as the submitted url (server default: false).
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
