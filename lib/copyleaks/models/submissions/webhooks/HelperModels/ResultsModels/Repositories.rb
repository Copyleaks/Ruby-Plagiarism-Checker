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
  class Repositories < SharedResultsModel
    attr_reader :repositoryId, :tags

    # @param [String] repositoryId - The repository Id that has the result.
    # @param [Array<Tags>] tags - Tags object array
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
