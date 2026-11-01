module Copyleaks
  class NewResultsRepositories < SharedResultsModel
    attr_reader :repositoryId

    def initialize(repositoryId:, metadata:)
      raise 'Copyleaks::NewResultsRepositories - repositoryId must be a String' unless repositoryId.is_a?(String)
      super(metadata: metadata)

      @repositoryId = repositoryId
    end

    # Always a RepositoryMetadata.
    def metadata
      super 
    end

    def as_json(*_args)
      {
        repositoryId: @repositoryId,
        metadata: metadata
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end