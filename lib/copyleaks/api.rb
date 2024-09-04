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
require 'net/http'
require 'json'
require 'date'
require_relative 'ai_detection_client.rb'
require_relative 'writing_assistant_client.rb'

module Copyleaks
  class API
    def initialize
      # copyleaks identity http client
      _identity_server_uri = URI.parse(Config.identity_server_uri)
      @id_client = Net::HTTP.new(_identity_server_uri.host, _identity_server_uri.port)
      @id_client.use_ssl = true
      # copyleaks api http client
      _api_server_uri = URI.parse(Config.api_server_uri)
      @api_client = Net::HTTP.new(_api_server_uri.host, _api_server_uri.port)
      @api_client.use_ssl = true

      # Initialize clients
      @ai_detection_client = AIDetectionClient.new(@api_client)
      @writing_assistant_client = WritingAssistantClient.new(@api_client)
    end

    # Login to Copyleaks authentication server.
    # For more info: https://api.copyleaks.com/documentation/v3/account/login.
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code, headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance. We recommend to implement exponential backoff algorithm as described here: https://api.copyleaks.com/documentation/v3/exponential-backoff
    # @param [String] email Copyleaks account email address.
    # @param [String] key Copyleaks account secret key.
    # @return A authentication token that being expired after certain amount of time.
    def login(email, key)
      raise 'email is Invalid, must be instance of String' if email.nil? || !email.instance_of?(String)
      raise 'key is Invalid, must be instance of String' if key.nil? || !email.instance_of?(String)

      path = '/v3/account/login/api'

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent
      }

      payload = { email: email, key: key }

      request = Net::HTTP::Post.new(path, headers)
      request.body = payload.to_json

      res_data = handle_response(@id_client.request(request), 'login')

      CopyleaksAuthToken.new(res_data['.expires'], res_data['access_token'], res_data['.issued'])
    end

    # Verify that Copyleaks authentication token is exists and not exipired.
    # * Exceptions:
    # * * AuthExipredException: authentication expired. Need to login again.
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    def verify_auth_token(authToken)
      if authToken.nil? || !authToken.instance_of?(CopyleaksAuthToken)
        raise 'authToken is Invalid, must be instance of CopyleaksAuthToken'
      end

      _time = DateTime.now
      _expiresTime = DateTime.parse(authToken.expires)

      if _expiresTime <= _time
        raise AuthExipredException.new.reason # expired
      end
    end


    # Starting a new process by providing a file to scan.
    # For more info:
    # https://api.copyleaks.com/documentation/v3/scans/submit/file
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Attach your own scan Id
    # @param [CopyleaksFileSubmissionModel] submission Submission properties
    def submit_file(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(CopyleaksFileSubmissionModel)
        raise 'submission is Invalid, must be instance of type CopyleaksFileSubmissionModel'
      end

      verify_auth_token(authToken)

      path = "/v3/scans/submit/file/#{scanId}"

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent,
        'Authorization' => "Bearer #{authToken.accessToken}"
      }

      request = Net::HTTP::Put.new(path, headers)
      request.body = submission.to_json

      handle_response(@api_client.request(request), 'submit_file')
    end

    # Starting a new process by providing a OCR image file to scan.
    # For more info:
    # https://api.copyleaks.com/documentation/v3/scans/submit/ocr
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Attach your own scan Id
    # @param [CopyleaksFileOcrSubmissionModel] submission Submission properties
    def submit_file_ocr(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(CopyleaksFileOcrSubmissionModel)
        raise 'submission is Invalid, must be instance of type CopyleaksFileOcrSubmissionModel'
      end

      verify_auth_token(authToken)

      path = "/v3/scans/submit/ocr/#{scanId}"

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent,
        'Authorization' => "Bearer #{authToken.accessToken}"
      }

      request = Net::HTTP::Put.new(path, headers)
      request.body = submission.to_json

      handle_response(@api_client.request(request), 'submit_file_ocr')
    end

    # Starting a new process by providing a URL to scan.
    # For more info:
    # https://api.copyleaks.com/documentation/v3/scans/submit/url
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Attach your own scan Id
    # @param [CopyleaksURLSubmissionModel] submission Submission properties
    def submit_url(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(CopyleaksURLSubmissionModel)
        raise 'submission is Invalid, must be instance of CopyleaksURLSubmissionModel'
      end

      verify_auth_token(authToken)

      path = "/v3/scans/submit/url/#{scanId}"

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent,
        'Authorization' => "Bearer #{authToken.accessToken}"
      }

      request = Net::HTTP::Put.new(path, headers)
      request.body = submission.to_json

      handle_response(@api_client.request(request), 'submit_url')
    end

    # Exporting scans artifact into your server.
    # For more info:
    # https://api.copyleaks.com/documentation/v3/downloads/export
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # @param [CopyleaksAuthToken] authToken Your login token to Copyleaks server
    # @param [String] scanId The scan ID of the specific scan to export.
    # @param [String] exportId A new Id for the export process.
    # @param [CopyleaksExportModel] model Request of which artifact should be exported.
    def export(authToken, scanId, exportId, model)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      raise 'exportId is Invalid, must be instance of String' if exportId.nil? || !exportId.instance_of?(String)
      if model.nil? || !model.instance_of?(CopyleaksExportModel)
        raise 'model is Invalid, must be instance of type CopyleaksExportModel'
      end

      verify_auth_token(authToken)
      path = "/v3/downloads/#{scanId}/export/#{exportId}"

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent,
        'Authorization' => "Bearer #{authToken.accessToken}"
      }

      request = Net::HTTP::Post.new(path, headers)
      request.body = model.to_json

      handle_response(@api_client.request(request), 'export')
    end

    # Start scanning all the files you submitted for a price-check.
    # For more info:
    # https://api.copyleaks.com/documentation/v3/scans/start
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # @param [CopyleaksAuthToken] authToken Your login token to Copyleaks server.
    # @param [CopyleaksStartRequestModel] data Include information about which scans should be started.
    def start(authToken, data)
      if data.nil? || !data.instance_of?(CopyleaksStartRequestModel)
        raise 'data is Invalid, must be instance of type CopyleaksStartRequestModel'
      end

      verify_auth_token(authToken)

      path =  "/v3/scans/start"

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent,
        'Authorization' => "Bearer #{authToken.accessToken}"
      }

      request = Net::HTTP::Patch.new(path, headers)
      request.body = data.to_json

      handle_response(@api_client.request(request), 'start')
    end


    # Delete the specific process from the server.
    # For more info:
    # https://api.copyleaks.com/documentation/v3/scans/delete
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [CopyleaksDeleteRequestModel] data
    def delete(authToken, data)
      if data.nil? || !data.instance_of?(CopyleaksDeleteRequestModel)
        raise 'data is Invalid, must be instance of CopyleaksDeleteRequestModel'
      end

      verify_auth_token(authToken)

      path = "/v3.1/scans/delete"

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent,
        'Authorization' => "Bearer #{authToken.accessToken}"
      }

      request = Net::HTTP::Patch.new(path, headers)
      request.body = data.to_json

      handle_response(@api_client.request(request), 'delete')
    end

    # Resend status webhooks for existing scans.
    # For more info:
    # https://api.copyleaks.com/documentation/v3/scans/webhook-resend
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Copyleaks scan Id
    def resend_webhook(authToken, scanId)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)

      verify_auth_token(authToken)

      path =  "/v3/scans/#{scanId}/webhooks/resend"

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent,
        'Authorization' => "Bearer #{authToken.accessToken}"
      }

      request = Net::HTTP::Post.new(path, headers)
      handle_response(@api_client.request(request), 'resend_webhook')
    end

    # Get current credits balance for the Copyleaks account.
    # For more info:
    # https://api.copyleaks.com/documentation/v3/scans/credits
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # * * RateLimitException: Too many requests. Please wait before calling again.
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    def get_credits_balance(authToken)
      verify_auth_token(authToken)

      path = "/v3/scans/credits"

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent,
        'Authorization' => "Bearer #{authToken.accessToken}"
      }

      request = Net::HTTP::Get.new(path, headers)
      handle_response(@api_client.request(request), 'get_credits_balance')
    end

    # This endpoint allows you to export your usage history between two dates.
    # The output results will be exported to a csv file and it will be attached to the response.
    # For more info:
    # https://api.copyleaks.com/documentation/v3/scans/usages/history
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # * * RateLimitException: Too many requests. Please wait before calling again.
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token.
    # @param [String] startDate The start date to collect usage history from. Date Format: `dd-MM-yyyy`.
    # @param [String] endDate The end date to collect usage history from. Date Format: `dd-MM-yyyy`.
    def get_usages_history_csv(authToken, startDate, endDate)
      raise 'startDate is Invalid, must be instance of String' if startDate.nil? || !startDate.instance_of?(String)
      raise 'endDate is Invalid, must be instance of String' if endDate.nil? || !endDate.instance_of?(String)

      verify_auth_token(authToken)

      path =  "/v3/scans/usages/history?start=#{startDate}&end=#{endDate}"

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent,
        'Authorization' => "Bearer #{authToken.accessToken}"
      }

      request = Net::HTTP::Get.new(path, headers)
      handle_response(@api_client.request(request), 'get_usages_history_csv')
    end

    # Get a list of the supported languages for OCR (this is not a list of supported languages for the api, but only for the OCR files scan).
    # For more info: https://api.copyleaks.com/documentation/v3/specifications/ocr-languages/list
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # * * RateLimitException: Too many requests. Please wait before calling again.
    # @return array List of supported OCR languages.
    def get_ocr_supported_languages
      path = '/v3/miscellaneous/ocr-languages-list'

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent
      }
      request = Net::HTTP::Get.new(path, headers)
      handle_response(@api_client.request(request), 'get_ocr_supported_languages')
    end

    # Get a list of the supported file types.
    # For more info: https://api.copyleaks.com/documentation/v3/specifications/supported-file-types
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # * * RateLimitException: Too many requests. Please wait before calling again.
    # @return mixed List of supported file types.
    def get_supported_file_types
      path =  '/v3/miscellaneous/supported-file-types'

      headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent
      }

      request = Net::HTTP::Get.new(path, headers)
      handle_response(@api_client.request(request), 'get_supported_file_types')
    end

    # Get updates about copyleaks api release notes.
    # For more info: https://api.copyleaks.com/documentation/v3/release-notes
    # * Exceptions:
    # * * CommandExceptions: Server reject the request. See response status code,
    #     headers and content for more info.
    # * * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance.
    #     We recommend to implement exponential backoff algorithm as described here:
    #     https://api.copyleaks.com/documentation/v3/exponential-backoff
    # * * RateLimitException: Too many requests. Please wait before calling again.
    # @return mixed List of release notes.
    def get_release_notes
      path = '/v3/release-logs.json'

      header = {
        'Content-Type' => 'application/json',
        'User-Agent' => Config.user_agent
      }
      request = Net::HTTP::Get.new(path, header)
      handle_response(@api_client.request(request), 'get_release_notes')
    end

    # this methods is a helper for hanlding reponse data and exceptions.
    def handle_response(response, used_by)
      if Utils.is_success_status_code(response.code)
        if response.body.nil? || response.body == ''
          nil
        else
          JSON.parse(response.body)
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

    def ai_detection_client
      @ai_detection_client
    end

    def writing_assistant_client
      @writing_assistant_client
    end
  end
end
