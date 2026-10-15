module Copyleaks
  class AIDetectionSubmissionModel
    attr_accessor :text, :sandbox

    # @param [Boolean] sandbox Free test mode. nil omits the field (server default: false).
    def initialize(text, sandbox = nil)
      unless text.instance_of?(String)
        raise 'Copyleaks::AIDetectionSubmissionModel - text - text must be of type String'
      end
      @text = text
      @sandbox = sandbox
    end

    def as_json(*_args)
      {
        'text' => @text,
        'sandbox' => @sandbox
      }.reject { |_, v| v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
