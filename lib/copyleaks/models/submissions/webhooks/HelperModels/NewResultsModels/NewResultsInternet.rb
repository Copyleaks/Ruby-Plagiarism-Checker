 #The MIT License(MIT)
 #Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
 #Permission is hereby granted, free of charge, to any person obtaining a copy
 #of this software and associated documentation files (the "Software"), to deal
 #in the Software without restriction, including without limitation the rights
 #to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 #copies of the Software, and to permit persons to whom the Software is
 #furnished to do so, subject to the following conditions:
 #The above copyright notice and this permission notice shall be included in all
 #copies or substantial portions of the Software.
 #THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 #IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 #FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
 #AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 #LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 #OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 #SOFTWARE.
 #=
module Copyleaks
  class NewResultsInternet
    attr_reader :id, :title, :introduction, :matchedWords, :scanId, :metadata, :url

    # @param [String] id
    # @param [String] title
    # @param [String] introduction
    # @param [Integer] matchedWords
    # @param [String] scanId
    # @param [Metadata] metadata
    # @param [String] url
    def initialize(id:, title:, introduction:, matchedWords:, scanId:, metadata:, url:)
      raise 'Copyleaks::NewResultsInternet - id must be a String' unless id.is_a?(String)
      raise 'Copyleaks::NewResultsInternet - title must be a String' unless title.is_a?(String)
      raise 'Copyleaks::NewResultsInternet - introduction must be a String' unless introduction.is_a?(String)
      raise 'Copyleaks::NewResultsInternet - matchedWords must be an Integer' unless matchedWords.is_a?(Integer)
      raise 'Copyleaks::NewResultsInternet - scanId must be a String' unless scanId.is_a?(String)
      raise 'Copyleaks::NewResultsInternet - metadata must be a Metadata' unless metadata.is_a?(Metadata)
      raise 'Copyleaks::NewResultsInternet - url must be a String' unless url.is_a?(String)

      @id = id
      @title = title
      @introduction = introduction
      @matchedWords = matchedWords
      @scanId = scanId
      @metadata = metadata
      @url = url
    end

    def as_json(*_args)
      {
        id: @id,
        title: @title,
        introduction: @introduction,
        matchedWords: @matchedWords,
        scanId: @scanId,
        metadata: @metadata,
        url: @url
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end