module Copyleaks
  class SubmissionAiSourceMatch
    # @param [Boolean] enable Find online sources suspected of containing AI-generated text. English documents
    #   only. nil omits the field (server default: false).
    def initialize(
      enable = nil
    )
      if !enable.nil? && ![true, false].include?(enable)
        raise 'Copyleaks::SubmissionAiSourceMatch - enable - enable must be of type Boolean'
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
