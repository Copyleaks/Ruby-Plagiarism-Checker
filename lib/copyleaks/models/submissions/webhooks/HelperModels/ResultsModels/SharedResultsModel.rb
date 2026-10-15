module Copyleaks
  class SharedResultsModel
    attr_reader :id, :title, :introduction, :matchedWords, :scanId, :metadata

    # @param [String, nil] scanId Set only when the result is your own submission in the Copyleaks internal database.
    def initialize(
      id: nil,
      title: nil,
      introduction: nil,
      matchedWords: nil,
      scanId: nil,
      metadata: nil
    )
      @id = id
      @title = title
      @introduction = introduction
      @matchedWords = matchedWords
      @scanId = scanId
      @metadata = metadata
    end
  end
end
