module Copyleaks
  class CopyleaksFileSubmissionModel < CopyleaksSubmissionModel
    attr_reader :base64, :filename, :properties

    # @param [String] base64 The file, base64-encoded. To scan plain text, base64-encode it.
    # @param [String] filename Shown in the scan report; include the right extension.
    def initialize(base64, filename, properties)
      unless base64.instance_of?(String)
        raise 'Copyleaks::CopyleaksFileSubmissionModel - base64 - base64 must be of type String'
      end
      unless filename.instance_of?(String)
        raise 'Copyleaks::CopyleaksFileSubmissionModel - filename - filename must be of type String'
      end
      unless properties.instance_of?(SubmissionProperties)
        raise 'Copyleaks::CopyleaksFileSubmissionModel - properties - properties must be of type SubmissionProperties'
      end

      super(properties)
      @base64 = base64
      @filename = filename
    end

    def as_json(*_args)
      {
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
