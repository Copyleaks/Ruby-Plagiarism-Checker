module Copyleaks
  class Internet < NewResultsInternet
    attr_reader :tags

    # @param [Array<Tags>] tags
    def initialize(tags:, **options)
      unless tags.is_a?(Array) && tags.all? { |tag| tag.is_a?(Tags) }
        raise 'Copyleaks::Internet - tags must be an Array of Tags'
      end

      super(**options)  # Initialize parent class with other params
      @tags = tags
    end

    def as_json(*_args)
      super.merge(tags: @tags)
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
