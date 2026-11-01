module Copyleaks
  # Citation Checker settings.
  class SubmissionReferences
    attr_reader :validate

    # @param [Boolean] validate Detect, parse and validate every reference in the text; the summary is in
    #   referencesValidation of the completed webhook. Server default: false.
    def initialize(validate = nil)
      if !validate.nil? && ![true, false].include?(validate)
        raise 'Copyleaks::SubmissionReferences - validate - validate must be of type Boolean'
      end

      @validate = validate
    end

    def as_json(*_args)
      {
        validate: @validate
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
