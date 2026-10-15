module Copyleaks
  class Score
    attr_reader :identicalWords, :minorChangedWords, :relatedMeaningWords, :aggregatedScore

    # @param [Integer] minorChangedWords Nearly identical words, like 'slow' and 'slowly'.
    # @param [Integer] relatedMeaningWords Paraphrased words: similar ideas in different words.
    # @param [Float] aggregatedScore Percentage of similar words in all results, excluding quotes, references, etc.
    def initialize(
      identicalWords: nil,
      minorChangedWords: nil,
      relatedMeaningWords: nil,
      aggregatedScore: nil
    )
      @identicalWords = identicalWords
      @minorChangedWords = minorChangedWords
      @relatedMeaningWords = relatedMeaningWords
      @aggregatedScore = aggregatedScore
    end
  end
end
