
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
  class Metadata
    attr_reader :finalUrl, :canonicalUrl, :publishDate, :creationDate,
                :lastModificationDate, :author, :organization, :filename

    # @param [String] finalUrl - The final URL of the document.
    # @param [String] canonicalUrl - The canonical URL if available.
    # @param [String] publishDate - The date the content was published.
    # @param [String] creationDate - The date the content was created.
    # @param [String] lastModificationDate - The last time the content was modified.
    # @param [String] author - The author of the content.
    # @param [String] organization - The organization associated with the content.
    # @param [String] filename - The original filename of the content.
    def initialize(finalUrl: nil, canonicalUrl: nil, publishDate: nil, creationDate: nil,
                   lastModificationDate: nil, author: nil, organization: nil, filename: nil)

      if !finalUrl.nil? && !finalUrl.is_a?(String)
        raise 'Copyleaks::Metadata - finalUrl must be a String'
      end
      if !canonicalUrl.nil? && !canonicalUrl.is_a?(String)
        raise 'Copyleaks::Metadata - canonicalUrl must be a String'
      end
      if !publishDate.nil? && !publishDate.is_a?(String)
        raise 'Copyleaks::Metadata - publishDate must be a String'
      end
      if !creationDate.nil? && !creationDate.is_a?(String)
        raise 'Copyleaks::Metadata - creationDate must be a String'
      end
      if !lastModificationDate.nil? && !lastModificationDate.is_a?(String)
        raise 'Copyleaks::Metadata - lastModificationDate must be a String'
      end
      if !author.nil? && !author.is_a?(String)
        raise 'Copyleaks::Metadata - author must be a String'
      end
      if !organization.nil? && !organization.is_a?(String)
        raise 'Copyleaks::Metadata - organization must be a String'
      end
      if !filename.nil? && !filename.is_a?(String)
        raise 'Copyleaks::Metadata - filename must be a String'
      end

      @finalUrl = finalUrl
      @canonicalUrl = canonicalUrl
      @publishDate = publishDate
      @creationDate = creationDate
      @lastModificationDate = lastModificationDate
      @author = author
      @organization = organization
      @filename = filename
    end

    def as_json(*_args)
      {
        finalUrl: @finalUrl,
        canonicalUrl: @canonicalUrl,
        publishDate: @publishDate,
        creationDate: @creationDate,
        lastModificationDate: @lastModificationDate,
        author: @author,
        organization: @organization,
        filename: @filename
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end