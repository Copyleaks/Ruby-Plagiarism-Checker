module Copyleaks
  class SubmissionIndexing
    # @param [SubmissionIndexingRepository[]] repositories Repositories to index the scanned document to.
    # @param [Boolean] copyleaksDb Add the document to the Copyleaks Shared Data Hub (server default: false).
    def initialize(repositories = nil, copyleaksDb: nil)
      if !copyleaksDb.nil? && ![true, false].include?(copyleaksDb)
        raise 'Copyleaks::SubmissionIndexing - copyleaksDb - copyleaksDb must be of type Boolean'
      end

      @repositories = repositories
      @copyleaksDb = copyleaksDb
    end

    def as_json(*_args)
      {
        repositories: @repositories,
        copyleaksDb: @copyleaksDb
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
