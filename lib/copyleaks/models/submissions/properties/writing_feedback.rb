module Copyleaks
  class SubmissionWritingFeedback
    attr_accessor :enable, :score

    # @param [Boolean] enable Grammar Checker: grammar, spelling and sentence structure corrections. Default false.
    # @param [ScoreWeights] score Optional weights of the writing aspects in the overall score.
    def initialize(enable = nil, score = nil)
      unless enable.nil? || [true, false].include?(enable)
        raise 'Copyleaks::SubmissionWritingFeedback - enable - enable must be of type Boolean'
      end
      unless score.nil? || score.is_a?(ScoreWeights)
        raise 'Copyleaks::SubmissionWritingFeedback - score - score must be of type ScoreWeights'
      end

      @enable = enable
      @score = score
    end

    def as_json(*_args)
      {
        enable: @enable,
        score: @score
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
