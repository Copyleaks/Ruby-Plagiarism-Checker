module Copyleaks
  class CommandException < RuntimeError
    attr_reader :response

    def initialize(response:, used_by:)
      @response = response
      @used_by = used_by

      message = "---------Copyleaks SDK Error (#{used_by})---------\n\n"
      message += "status code: #{response.code}\n\n"
      message += "response body:\n#{response.body.to_json}\n\n" unless response.body.nil?
      message += "-------------------------------------\n"
      super message
    end
  end
end
