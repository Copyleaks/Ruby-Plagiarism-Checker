module Copyleaks
  class NaturalLanguageSubmissionModel < AIDetectionSubmissionModel
    attr_accessor :language, :explain, :sensitivity

    # Arguments left nil are not sent, so the server default applies.
    # @param [String] text 255 to 100,000 characters.
    # @param [String] language Language code; auto-detected when nil.
    # @param [Boolean] sandbox Free test mode (server default: false).
    # @param [Boolean] explain AI Logic: the response includes explain, the patterns behind the result. Default false.
    # @param [Integer] sensitivity 1 to 3, default 2: 1 finds unedited AI text, 3 also heavily edited AI text.
    def initialize(text, language = nil, sandbox = nil, explain: nil, sensitivity: nil)
      unless text.instance_of?(String)
        raise 'Copyleaks::NaturalLanguageSubmissionModel - text - text must be of type String'
      end
      if !explain.nil? && ![true, false].include?(explain)
        raise 'Copyleaks::NaturalLanguageSubmissionModel - explain - explain must be of type Boolean'
      end
      if !sensitivity.nil? && !(sensitivity.is_a?(Integer) && sensitivity.between?(1, 3))
        raise 'Copyleaks::NaturalLanguageSubmissionModel - sensitivity - sensitivity must be an Integer from 1 to 3'
      end
      super(text, sandbox)
      @language = language
      @explain = explain
      @sensitivity = sensitivity
    end

    def as_json(*_args)
      {
        text: @text,
        sandbox: @sandbox,
        language: @language,
        explain: @explain,
        sensitivity: @sensitivity
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
