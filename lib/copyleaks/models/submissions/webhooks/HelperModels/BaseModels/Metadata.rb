
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
    attr_reader :final_url, :canonical_url, :publish_date, :creation_date,
                :last_modification_date, :author, :organization, :filename

    # @param [String] final_url - The final URL of the document.
    # @param [String] canonical_url - The canonical URL if available.
    # @param [String] publish_date - The date the content was published.
    # @param [String] creation_date - The date the content was created.
    # @param [String] last_modification_date - The last time the content was modified.
    # @param [String] author - The author of the content.
    # @param [String] organization - The organization associated with the content.
    # @param [String] filename - The original filename of the content.
    def initialize(final_url: nil, canonical_url: nil, publish_date: nil, creation_date: nil,
                   last_modification_date: nil, author: nil, organization: nil, filename: nil)

      if !final_url.nil? && !final_url.is_a?(String)
        raise 'Copyleaks::Metadata - final_url must be a String'
      end
      if !canonical_url.nil? && !canonical_url.is_a?(String)
        raise 'Copyleaks::Metadata - canonical_url must be a String'
      end
      if !publish_date.nil? && !publish_date.is_a?(String)
        raise 'Copyleaks::Metadata - publish_date must be a String'
      end
      if !creation_date.nil? && !creation_date.is_a?(String)
        raise 'Copyleaks::Metadata - creation_date must be a String'
      end
      if !last_modification_date.nil? && !last_modification_date.is_a?(String)
        raise 'Copyleaks::Metadata - last_modification_date must be a String'
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

      @final_url = final_url
      @canonical_url = canonical_url
      @publish_date = publish_date
      @creation_date = creation_date
      @last_modification_date = last_modification_date
      @author = author
      @organization = organization
      @filename = filename
    end

    def as_json(*_args)
      {
        finalUrl: @final_url,
        canonicalUrl: @canonical_url,
        publishDate: @publish_date,
        creationDate: @creation_date,
        lastModificationDate: @last_modification_date,
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