#
#  The MIT License(MIT)
#
#  Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
# =

module Copyleaks
  class ClientUtils
    def self.handle_response(response, used_by)
      if Utils.is_success_status_code(response.code)
        if response.body.nil? || response.body == ''
          nil
        else
          parsed_response = JSON.parse(response.body)
          puts "Parsed response: #{parsed_response.inspect}"
          parsed_response
        end
      elsif Utils.is_under_maintenance_response(response.code)
        raise UnderMaintenanceException.new.reason
      elsif Utils.is_rate_limit_response(response.code)
        raise RateLimitException.new.reason
      else
        _err_message = '---------Copyleaks SDK Error (' + used_by + ')---------' + "\n\n"
        _err_message += 'status code: ' + response.code + "\n\n"

        _err_message += 'response body:' + "\n" + response.body.to_json + "\n\n" unless response.body.nil?

        _err_message += '-------------------------------------'
        raise CommandException.new(_err_message).reason + "\n"
      end
    end

    def self.verify_auth_token(authToken)
      if authToken.nil? || !authToken.instance_of?(CopyleaksAuthToken)
        raise 'authToken is Invalid, must be instance of CopyleaksAuthToken'
      end

      _time = DateTime.now
      _expiresTime = DateTime.parse(authToken.expires)

      if _expiresTime <= _time
        raise AuthExipredException.new.reason # expired
      end
    end
  end
end
