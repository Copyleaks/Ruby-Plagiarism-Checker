# frozen_string_literal: true

module Copyleaks
  # Optional metadata extracted from the image.
  class CopyleaksImageMetadataModel
    # When the image was created, if available.
    attr_accessor :issued_time

    # The AI service or tool that created the image, if detected.
    attr_accessor :issued_by

    attr_accessor :app_or_device_used

    # How the image was generated, if available.
    attr_accessor :content_summary

    def initialize(issued_time: nil, issued_by: nil, app_or_device_used: nil, content_summary: nil)
      @issued_time = issued_time
      @issued_by = issued_by
      @app_or_device_used = app_or_device_used
      @content_summary = content_summary
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        issued_time: json_hash['issuedTime'],
        issued_by: json_hash['issuedBy'],
        app_or_device_used: json_hash['appOrDeviceUsed'],
        content_summary: json_hash['contentSummary']
      )
    end

    def to_json(*args)
      hash = {
        'issuedTime' => @issued_time,
        'issuedBy' => @issued_by,
        'appOrDeviceUsed' => @app_or_device_used
      }
      hash['contentSummary'] = @content_summary unless @content_summary.nil?
      hash.to_json(*args)
    end
  end
end