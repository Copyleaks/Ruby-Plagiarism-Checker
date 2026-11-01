module Copyleaks
  class Database < SharedResultsModel
    attr_reader :tags

    # @param [Array<Tags>] tags
    def initialize(tags:, **options)
      unless tags.is_a?(Array) && tags.all? { |tag| tag.is_a?(Tags) }
        raise 'Copyleaks::Database - tags must be an Array of Tags'
      end

      super(**options) # Pass any other options to SharedResultsModel

      @tags = tags
    end

    def as_json(*_args)
      {
        tags: @tags
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
