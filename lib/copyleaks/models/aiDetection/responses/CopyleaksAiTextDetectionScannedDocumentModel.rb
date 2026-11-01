require_relative '../../textModeration/responses/submodules/TextModerationScannedDocument.rb'

module Copyleaks
  # Metadata about an AI Text Detection scan. Unlike the base class, fields default to nil, creation_time stays
  # the ISO 8601 String, and unset fields are left out of the JSON.
  class CopyleaksAiTextDetectionScannedDocumentModel < TextModerationScannedDocument
    def initialize(scan_id: nil, total_words: nil, total_excluded: nil, actual_credits: nil, expected_credits: nil,
                   creation_time: nil)
      super
    end

    def self.parse_creation_time(value)
      value
    end
    private_class_method :parse_creation_time

    def as_json(*_args)
      super.compact
    end
  end
end
