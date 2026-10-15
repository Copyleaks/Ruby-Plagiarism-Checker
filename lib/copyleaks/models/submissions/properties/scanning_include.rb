module Copyleaks
  class SubmissionScanningInclude
    attr_reader :idPattern

    # @param [String] idPattern Only include internal database and repository results whose scan id matches.
    #   Wildcards: '*' any characters, '.' one non-whitespace character.
    def initialize(idPattern = nil)
      if !idPattern.nil? && !idPattern.instance_of?(String)
        raise 'Copyleaks::SubmissionScanningInclude - idPattern - idPattern must be of type String'
      end

      @idPattern = idPattern
    end

    def as_json(*_args)
      {
        idPattern: @idPattern
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
