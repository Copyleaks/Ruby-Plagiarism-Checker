module Copyleaks
  class CreditsCheckedWebhook < StatusWebhook
    attr_reader :credits, :scannedDocument

    def initialize(credits: nil, scannedDocument: nil, **args)
      super(**args)
      @credits = credits
      @scannedDocument = scannedDocument
    end

    def as_json(*_args)
      super.merge(
        {
          credits: @credits,
          scannedDocument: @scannedDocument.respond_to?(:as_json) ? @scannedDocument.as_json : @scannedDocument
        }
      )
    end

    def to_json(*options)
      as_json.to_json(*options)
    end
  end
end
