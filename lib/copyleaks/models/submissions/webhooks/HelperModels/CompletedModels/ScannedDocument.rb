 #The MIT License(MIT)
 #Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
 #Permission is hereby granted, free of charge, to any person obtaining a copy
 #of this software and associated documentation files (the "Software"), to deal
 #in the Software without restriction, including without limitation the rights
 #to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 #copies of the Software, and to permit persons to whom the Software is
 #furnished to do so, subject to the following conditions:
 #The above copyright notice and this permission notice shall be included in all
 #copies or substantial portions of the Software.
 #THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 #IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 #FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
 #AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 #LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 #OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 #SOFTWARE.
 #=

module Copyleaks
  class ScannedDocument
    attr_reader :scanId, :totalWords, :totalExcluded, :credits, :creationTime, :metadata

    # @param [String] scanId - The scan ID.
    # @param [Integer] totalWords - Total number of words in the document.
    # @param [Integer] totalExcluded - Total number of excluded words.
    # @param [Integer] credits - Number of credits used for the scan.
    # @param [String] creationTime - The time the scan was created.
    # @param [Metadata] metadata - Metadata associated with the document.
    def initialize(scanId:, totalWords:, totalExcluded:, credits:, creationTime:, metadata:)
      raise 'scanId must be a String' unless scanId.is_a?(String)
      raise 'totalWords must be an Integer' unless totalWords.is_a?(Integer)
      raise 'totalExcluded must be an Integer' unless totalExcluded.is_a?(Integer)
      raise 'credits must be an Integer' unless credits.is_a?(Integer)
      raise 'creationTime must be a String' unless creationTime.is_a?(String)
      raise 'metadata must be a Metadata object' unless metadata.is_a?(Metadata)

      @scanId = scanId
      @totalWords = totalWords
      @totalExcluded = totalExcluded
      @credits = credits
      @creationTime = creationTime
      @metadata = metadata
    end

    def as_json(*_args)
      {
        scanId: @scanId,
        totalWords: @totalWords,
        totalExcluded: @totalExcluded,
        credits: @credits,
        creationTime: @creationTime,
        metadata: @metadata
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end