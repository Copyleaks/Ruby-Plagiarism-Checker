module Copyleaks
  class SubmissionCourse
    attr_reader :id

    # @param [String] id A unique course identifier, used for tracking analytics.
    def initialize(id)
      raise 'Copyleaks::SubmissionCourse - id - id must be of type String' unless id.instance_of?(String)

      @id = id
    end

    def as_json(*_args)
      {
        id: @id
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
