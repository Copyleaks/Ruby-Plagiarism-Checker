module Copyleaks
  class SubmissionExcludeCode
    def initialize(
      comments = nil
    )
      @comments = comments
    end

    def as_json(*_args)
      {
        comments: @comments
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
