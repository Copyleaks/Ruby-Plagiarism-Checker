module Copyleaks
  class SubmissionAuthor
    # @param [String] id Unique author id. Reuse it for the same author so Copyleaks learns their writing patterns.
    def initialize(id)
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
