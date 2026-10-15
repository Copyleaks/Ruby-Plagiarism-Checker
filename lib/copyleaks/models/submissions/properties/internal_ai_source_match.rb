module Copyleaks
  class SubmissionInternalAiSourceMatch
    attr_reader :enable

    # @param [Boolean] enable Find sources in the Copyleaks internal AI database that contain AI-generated text,
    #   reported in results.internalAIData of the completed webhook. Server default: false.
    def initialize(enable = nil)
      if !enable.nil? && ![true, false].include?(enable)
        raise 'Copyleaks::SubmissionInternalAiSourceMatch - enable - enable must be of type Boolean'
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
