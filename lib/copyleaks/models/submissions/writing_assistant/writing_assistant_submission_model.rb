module Copyleaks
  class WritingAssistantSubmissionModel
    attr_accessor :text, :sandbox, :language, :score

    # @param [String] text 1 to 25,000 characters.
    # @param [Boolean] sandbox Test without using credits. nil omits the field (server default: false).
    # @param [String] language Language code; auto-detected when nil.
    # @param [ScoreWeights] score Optional weights of the writing aspects in the overall score.
    def initialize(text, sandbox = nil, language = nil, score = nil)
      unless text.instance_of?(String)
        raise 'Copyleaks::WritingAssistantSubmissionModel - text - text must be of type String'
      end
      @text = text
      @sandbox = sandbox
      @language = language
      @score = score
    end

    def as_json(*_args)
      {
        text: @text,
        sandbox: @sandbox,
        language: @language,
        score: @score
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
