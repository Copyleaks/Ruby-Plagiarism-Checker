module Copyleaks
  class Metadata
    attr_reader :finalUrl, :canonicalUrl, :publishDate, :creationDate,
                :lastModificationDate, :author, :organization, :filename

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