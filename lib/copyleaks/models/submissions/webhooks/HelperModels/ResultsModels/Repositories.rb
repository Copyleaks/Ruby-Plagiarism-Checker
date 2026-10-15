module Copyleaks
  class Repositories < SharedResultsModel
    attr_reader :repositoryId, :tags

    # @param [Array<Tags>] tags
    def initialize(repositoryId:, tags:, **options)
      unless repositoryId.is_a?(String)
        raise 'Copyleaks::Repositories - repositoryId must be a String'
      end

      unless tags.is_a?(Array) && tags.all? { |tag| tag.is_a?(Tags) }
        raise 'Copyleaks::Repositories - tags must be an Array of Tags'
      end

      super(**options) 

      @repositoryId = repositoryId
      @tags = tags
    end

    def metadata
      super 
    end

    def as_json(*_args)
      {
        repositoryId: @repositoryId,
        tags: @tags
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
