module Copyleaks
  # A property with a single enable flag. Base of SubmissionAiSourceMatch, SubmissionInternalAiSourceMatch and
  # SubmissionAiGeneratedTextExplain.
  class SubmissionEnableFlag
    attr_reader :enable

    # @param [Boolean] enable nil omits the field (server default: false).
    def initialize(enable = nil)
      if !enable.nil? && ![true, false].include?(enable)
        raise "Copyleaks::#{self.class.name.split('::').last} - enable - enable must be of type Boolean"
      end

      @enable = enable
    end

    def as_json(*_args)
      {
        enable: @enable
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
