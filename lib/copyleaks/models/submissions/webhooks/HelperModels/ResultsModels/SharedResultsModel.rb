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
  class SharedResultsModel
    attr_reader :id, :title, :introduction, :matchedWords, :scanId, :metadata

     # @param [string] $id - Unique result ID to identify this result.
     # @param [string] $introduction - Document brief introduction. Mostly extracted from the document content.
     # @param [int] $matchedWords - Total matched words between this result and the scanned document.
     # @param [string|null] $scanId - In case a result was found in the Copyleaks internal database and was submitted by you, this will show the scan id of the specific result. Otherwise, this field will remain empty.
     # @param [Metadata] $metadata - Metadata object.
     # @param [string] $title - Document title. Mostly extracted from the document content.
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
