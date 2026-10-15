module Copyleaks
  class SubmissionAiGeneratedText
    attr_reader :detect, :sensitivity, :explain

    # Fields left nil are not sent, so the server default applies.
    # @param [Boolean] detect Detect AI-written text (server default: false).
    # @param [Integer] sensitivity 1 to 3, default 2: 1 finds unedited AI text, 3 also heavily edited AI text.
    # @param [SubmissionAiGeneratedTextExplain, Boolean] explain AI Logic explanations.
    #   true is the same as SubmissionAiGeneratedTextExplain.new(true).
    def initialize(detect = nil, sensitivity: nil, explain: nil)
      if !detect.nil? && ![true, false].include?(detect)
        raise 'Copyleaks::SubmissionAiGeneratedText - detect - detect must be of type Boolean'
      end
      if !sensitivity.nil? && !(sensitivity.is_a?(Integer) && sensitivity.between?(1, 3))
        raise 'Copyleaks::SubmissionAiGeneratedText - sensitivity - sensitivity must be an Integer from 1 to 3'
      end

      explain = SubmissionAiGeneratedTextExplain.new(explain) if [true, false].include?(explain)
      if !explain.nil? && !explain.instance_of?(SubmissionAiGeneratedTextExplain)
        raise 'Copyleaks::SubmissionAiGeneratedText - explain - explain must be of type SubmissionAiGeneratedTextExplain'
      end

      @detect = detect
      @sensitivity = sensitivity
      @explain = explain
    end

    def as_json(*_args)
      {
        detect: @detect,
        sensitivity: @sensitivity,
        explain: @explain
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
