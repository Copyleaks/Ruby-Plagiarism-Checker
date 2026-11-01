module Copyleaks
  class RepositoryMetadata < Metadata
    # Email of the user who added this document to the repository.
    attr_reader :submittedBy

    def initialize(submittedBy: nil, **args)
      super(**args)
      @submittedBy = submittedBy
    end
  end
end