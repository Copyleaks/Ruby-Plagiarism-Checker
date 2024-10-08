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
  class ScoreWeights
    # @param [Float] Grammar correction category weight in the overall score. 0.0 >= weight <= 1.0
    # @param [Float] Mechanics correction category weight in the overall score. 0.0 >= weight <= 1.0
    # @param [Float] Sentence structure correction category weight in the overall score. 0.0 >= weight <= 1.0
    # @param [Float] Word choice correction category weight in the overall score. 0.0 >= weight <= 1.0

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
