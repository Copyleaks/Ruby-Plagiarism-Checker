module Copyleaks
  class NewResultsInternet
    attr_reader :id, :title, :introduction, :matchedWords, :metadata, :url

    # scanId is accepted for compatibility with earlier versions and is not used: internet results have no scan id.
    def initialize(id:, title:, introduction:, matchedWords:, metadata:, url:, scanId: nil)
      raise 'Copyleaks::NewResultsInternet - id must be a String' unless id.is_a?(String)
      raise 'Copyleaks::NewResultsInternet - title must be a String' unless title.is_a?(String)
      raise 'Copyleaks::NewResultsInternet - introduction must be a String' unless introduction.is_a?(String)
      raise 'Copyleaks::NewResultsInternet - matchedWords must be an Integer' unless matchedWords.is_a?(Integer)
      raise 'Copyleaks::NewResultsInternet - metadata must be a Metadata' unless metadata.is_a?(Metadata)
      raise 'Copyleaks::NewResultsInternet - url must be a String' unless url.is_a?(String)

      @id = id
      @title = title
      @introduction = introduction
      @matchedWords = matchedWords
      @metadata = metadata
      @url = url
    end

    def as_json(*_args)
      {
        id: @id,
        title: @title,
        introduction: @introduction,
        matchedWords: @matchedWords,
        metadata: @metadata,
        url: @url
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end