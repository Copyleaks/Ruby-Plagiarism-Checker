module Copyleaks
  class NewResultScore
    attr_reader :aggregatedScore

    # @param [Float] aggregatedScore Percentage of similar words in all results, excluding quotes, references, etc.
    def initialize(aggregatedScore:)
      raise 'Copyleaks::NewResultScore - aggregatedScore must be a Float' unless aggregatedScore.is_a?(Float) || aggregatedScore.is_a?(Integer)
      
      @aggregatedScore = aggregatedScore.to_f
    end

    def as_json(*_args)
      {
        aggregatedScore: @aggregatedScore
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end