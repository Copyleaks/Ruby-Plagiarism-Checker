module Copyleaks
  class CopyleaksFileOcrSubmissionModel < CopyleaksFileSubmissionModel
    # Same as CopyleaksFileSubmissionModel, plus the content language.
    # @param [String] langCode One of API#get_ocr_supported_languages.
    def initialize(langCode, base64, filename, properties)
      unless langCode.instance_of?(String)
        raise 'Copyleaks::CopyleaksFileOcrSubmissionModel - langCode - langCode must be of type String'
      end
      unless base64.instance_of?(String)
        raise 'Copyleaks::CopyleaksFileOcrSubmissionModel - base64 - base64 must be of type String'
      end
      unless filename.instance_of?(String)
        raise 'Copyleaks::CopyleaksFileOcrSubmissionModel - filename - filename must be of type String'
      end
      unless properties.instance_of?(SubmissionProperties)
        raise 'Copyleaks::CopyleaksFileOcrSubmissionModel - properties - properties must be of type SubmissionProperties'
      end

      super(base64, filename, properties)
      @langCode = langCode
    end

    def as_json(*_args)
      {
        langCode: @langCode,
        base64: @base64,
        filename: @filename,
        properties: @properties
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
