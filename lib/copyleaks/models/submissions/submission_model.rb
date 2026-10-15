module Copyleaks
  class CopyleaksSubmissionModel
    attr_reader :properties

    # @param [SubmissionProperties] properties
    def initialize(properties)
      unless properties.instance_of?(SubmissionProperties)
        raise 'Copyleaks::CopyleaksURLSubmissionModel - properties - properties must be of type SubmissionProperties'
      end

      @properties = properties
    end

    def as_json(*_args)
      {
        properties: @properties
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
