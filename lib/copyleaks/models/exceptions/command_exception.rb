module Copyleaks
  class CommandException < CopyleaksApiException
    def initialize(response:, used_by:)
      @used_by = used_by

      message = "---------Copyleaks SDK Error (#{used_by})---------\n\n"
      message += "status code: #{response.code}\n\n"
      message += "response body:\n#{response.body.to_json}\n\n" unless response.body.nil?
      message += "-------------------------------------\n"
      super(message, response)
    end
  end
end
