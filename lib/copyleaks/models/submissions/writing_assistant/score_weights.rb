module Copyleaks
  # Weight of each correction category in the overall score, 0.0 to 1.0.
  class ScoreWeights
    attr_accessor :grammar_score_weight, :mechanics_score_weight, :sentence_structure_score_weight, :word_choice_score_weight

    def initialize(grammar_score_weight, mechanics_score_weight, sentence_structure_score_weight, word_choice_score_weight)
      @grammar_score_weight = grammar_score_weight
      @mechanics_score_weight = mechanics_score_weight
      @sentence_structure_score_weight = sentence_structure_score_weight
      @word_choice_score_weight = word_choice_score_weight
    end

    def as_json(*_args)
      {
        grammarScoreWeight: @grammar_score_weight,
        mechanicsScoreWeight: @mechanics_score_weight,
        sentenceStructureScoreWeight: @sentence_structure_score_weight,
        wordChoiceScoreWeight: @word_choice_score_weight
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
