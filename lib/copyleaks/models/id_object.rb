module Copyleaks
  # An object with a String id. Base of SubmissionCourse, SubmissionAssignment and SubmissionInstitution.
  class IdObject
    attr_reader :id

    def initialize(id)
      raise "Copyleaks::#{self.class.name.split('::').last} - id - id must be of type String" unless id.instance_of?(String)

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
