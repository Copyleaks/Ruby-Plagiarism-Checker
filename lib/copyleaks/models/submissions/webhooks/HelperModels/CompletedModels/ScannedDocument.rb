module Copyleaks
  class ScannedDocument
    attr_reader :scanId, :totalWords, :totalExcluded, :credits, :creationTime, :metadata

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