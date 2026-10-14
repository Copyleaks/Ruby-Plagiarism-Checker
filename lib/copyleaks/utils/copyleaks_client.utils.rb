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
require 'json'
require 'net/http'
require 'uri'

module Copyleaks
  class ClientUtils
    REQUEST_CLASSES = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
      put: Net::HTTP::Put,
      patch: Net::HTTP::Patch
    }.freeze

    def self.handle_response(response, used_by)
      if Utils.is_success_status_code(response.code)
        if response.body.nil? || response.body == ''
          nil
        else
          JSON.parse(response.body)
        end
      elsif Utils.is_under_maintenance_response(response.code)
        raise UnderMaintenanceException.new(response)
      elsif Utils.is_rate_limit_response(response.code)
        raise RateLimitException.new(response)
      else
        raise CommandException.new(response: response, used_by: used_by)
      end
    end

    # Builds one request. A JSON body is serialized with to_json; a MultipartForm is sent as
    # multipart/form-data. Requests without a body still declare JSON, as earlier versions did.
    def self.build_request(method, path, auth_token: nil, json: nil, multipart: nil)
      klass = REQUEST_CLASSES.fetch(method)
      headers = { 'User-Agent' => Config.user_agent }
      headers['Authorization'] = "Bearer #{auth_token.accessToken}" unless auth_token.nil?
      if multipart.nil?
        headers['Content-Type'] = 'application/json'
      else
        headers['Content-Type'] = multipart.content_type
      end

      request = klass.new(path, headers)
      if !multipart.nil?
        request.body = multipart.body
      elsif !json.nil?
        request.body = json.is_a?(String) ? json : json.to_json
      end
      request
    end

    # Sends one request through the connection pool and returns the parsed JSON response.
    def self.send_request(http_client, method, path, used_by, auth_token: nil, json: nil, multipart: nil)
      request = build_request(method, path, auth_token: auth_token, json: json, multipart: multipart)
      handle_response(http_client.request(request), used_by)
    end

    # Percent-encodes one path segment (a scan id, export id, repository id or language code),
    # so characters such as space, '/', '?', '#' and '%' cannot change the request path.
    # Only the RFC 3986 unreserved characters (letters, digits, '-', '.', '_', '~') are left as is;
    # every other byte, including each byte of a multi-byte UTF-8 character, becomes %XX.
    def self.escape_path(segment)
      segment.to_s.b.gsub(/[^A-Za-z0-9\-._~]/n) { |byte| format('%%%02X', byte.ord) }.force_encoding(Encoding::UTF_8)
    end

    def self.verify_auth_token(authToken)
      if authToken.nil? || !authToken.instance_of?(CopyleaksAuthToken)
        raise 'authToken is Invalid, must be instance of CopyleaksAuthToken'
      end

      raise AuthExpiredException if authToken.expired?
    end
  end
end
