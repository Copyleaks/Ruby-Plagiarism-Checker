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
require 'uri'
require_relative 'utils/http_client.rb'
require_relative 'utils/multipart.rb'
require_relative 'utils/copyleaks_client.utils.rb'
require_relative 'ai_detection_client.rb'
require_relative 'writing_assistant_client.rb'
require_relative 'text_moderation_client.rb'
require_relative 'ai_image_detection_client.rb'
require_relative 'ai_video_detection_client.rb'
require_relative 'image_plagiarism_client.rb'

module Copyleaks
  # Entry point of the SDK.
  #
  # One instance is safe to share between threads. It keeps a small pool of persistent
  # connections to each Copyleaks server, so calls reuse connections instead of opening
  # a new TCP and TLS session every time.
  #
  # Errors raised by every call:
  # * CommandException: the server rejected the request. See exception.response for the status code, headers and body.
  # * UnderMaintenanceException: Copyleaks servers are unavailable for maintenance (HTTP 503).
  # * RateLimitException: too many requests (HTTP 429). See exception.retry_after.
  # * AuthExpiredException: the login token has expired. Log in again.
  # * Net::OpenTimeout, Net::ReadTimeout, Net::WriteTimeout and socket errors: the request did not complete.
  #   Requests are never resent automatically. Before resubmitting a scan after a timeout, note that
  #   the first request may have been accepted; a second submit with the same scan id returns 409 Conflict.
  # Retry 429 and 503 with exponential backoff: https://docs.copyleaks.com/concepts/performance/handling-failures
  class API
    attr_reader :ai_detection_client, :writing_assistant_client, :text_moderation_client,
                :ai_image_detection_client, :ai_video_detection_client, :image_plagiarism_client

    # @param [Numeric] open_timeout Seconds to wait for the connection and the TLS handshake. Default 10.
    # @param [Numeric] read_timeout Seconds to wait for each read of a response. Default 120.
    # @param [Numeric] write_timeout Seconds to wait for each write of a request body. Default 120.
    # @param [Numeric] keep_alive_timeout Seconds an idle connection is kept open for reuse. Default 30.
    # @param [Integer] pool_size Maximum open connections per Copyleaks server. Default 5.
    # @param [String] identity_server_uri Overrides Copyleaks::Config.identity_server_uri for this client.
    # @param [String] api_server_uri Overrides Copyleaks::Config.api_server_uri for this client.
    def initialize(open_timeout: HttpClient::DEFAULT_OPEN_TIMEOUT,
                   read_timeout: HttpClient::DEFAULT_READ_TIMEOUT,
                   write_timeout: HttpClient::DEFAULT_WRITE_TIMEOUT,
                   keep_alive_timeout: HttpClient::DEFAULT_KEEP_ALIVE_TIMEOUT,
                   pool_size: HttpClient::DEFAULT_POOL_SIZE,
                   identity_server_uri: nil,
                   api_server_uri: nil)
      options = {
        open_timeout: open_timeout,
        read_timeout: read_timeout,
        write_timeout: write_timeout,
        keep_alive_timeout: keep_alive_timeout,
        pool_size: pool_size
      }
      # copyleaks identity http client
      @id_client = HttpClient.new(identity_server_uri || Config.identity_server_uri, **options)
      # copyleaks api http client
      @api_client = HttpClient.new(api_server_uri || Config.api_server_uri, **options)

      # Initialize clients
      @ai_detection_client = AIDetectionClient.new(@api_client)
      @writing_assistant_client = WritingAssistantClient.new(@api_client)
      @text_moderation_client = TextModerationClient.new(@api_client)
      @ai_image_detection_client = AIImageDetectionClient.new(@api_client)
      @ai_video_detection_client = AIVideoDetectionClient.new(@api_client)
      @image_plagiarism_client = ImagePlagiarismClient.new(@api_client)
    end

    # Closes the idle pooled connections. The client stays usable and reconnects when needed.
    def close
      @id_client.close
      @api_client.close
      nil
    end

    # Login to Copyleaks authentication server.
    # For more info: https://docs.copyleaks.com/reference/actions/account/login
    # @param [String] email Copyleaks account email address.
    # @param [String] key Copyleaks account secret key.
    # @return [CopyleaksAuthToken] An authentication token that expires after a certain amount of time.
    def login(email, key)
      raise 'email is Invalid, must be instance of String' if email.nil? || !email.instance_of?(String)
      raise 'key is Invalid, must be instance of String' if key.nil? || !key.instance_of?(String)

      payload = { email: email, key: key }
      res_data = ClientUtils.send_request(@id_client, :post, '/v3/account/login/api', 'login', json: payload)

      CopyleaksAuthToken.new(res_data['.expires'], res_data['access_token'], res_data['.issued'])
    end

    # Verify that a Copyleaks authentication token exists and has not expired.
    # A token that expires within the next 5 minutes is treated as expired.
    # * Exceptions:
    # * * AuthExpiredException: authentication expired. Need to login again.
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    def verify_auth_token(authToken)
      ClientUtils.verify_auth_token(authToken)
    end

    # Starting a new process by providing a file to scan.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/submit-file
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Attach your own scan Id
    # @param [CopyleaksFileSubmissionModel] submission Submission properties
    def submit_file(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(CopyleaksFileSubmissionModel)
        raise 'submission is Invalid, must be instance of type CopyleaksFileSubmissionModel'
      end

      verify_auth_token(authToken)

      path = "/v3/scans/submit/file/#{ClientUtils.escape_path(scanId)}"
      ClientUtils.send_request(@api_client, :put, path, 'submit_file', auth_token: authToken, json: submission)
    end

    # Starting a new process by providing a OCR image file to scan.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/submit-ocr
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Attach your own scan Id
    # @param [CopyleaksFileOcrSubmissionModel] submission Submission properties
    def submit_file_ocr(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(CopyleaksFileOcrSubmissionModel)
        raise 'submission is Invalid, must be instance of type CopyleaksFileOcrSubmissionModel'
      end

      verify_auth_token(authToken)

      path = "/v3/scans/submit/ocr/#{ClientUtils.escape_path(scanId)}"
      ClientUtils.send_request(@api_client, :put, path, 'submit_file_ocr', auth_token: authToken, json: submission)
    end

    # Starting a new process by providing a URL to scan.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/submit-url
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Attach your own scan Id
    # @param [CopyleaksURLSubmissionModel] submission Submission properties
    def submit_url(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(CopyleaksURLSubmissionModel)
        raise 'submission is Invalid, must be instance of CopyleaksURLSubmissionModel'
      end

      verify_auth_token(authToken)

      path = "/v3/scans/submit/url/#{ClientUtils.escape_path(scanId)}"
      ClientUtils.send_request(@api_client, :put, path, 'submit_url', auth_token: authToken, json: submission)
    end

    # Exporting scans artifact into your server.
    # For more info: https://docs.copyleaks.com/reference/actions/downloads/export
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

      path = "/v3/downloads/#{ClientUtils.escape_path(scanId)}/export/#{ClientUtils.escape_path(exportId)}"
      ClientUtils.send_request(@api_client, :post, path, 'export', auth_token: authToken, json: model)
    end

    # Start scanning all the files you submitted for a price-check.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/start
    # @param [CopyleaksAuthToken] authToken Your login token to Copyleaks server.
    # @param [CopyleaksStartRequestModel] data Include information about which scans should be started.
    def start(authToken, data)
      if data.nil? || !data.instance_of?(CopyleaksStartRequestModel)
        raise 'data is Invalid, must be instance of type CopyleaksStartRequestModel'
      end

      verify_auth_token(authToken)

      ClientUtils.send_request(@api_client, :patch, '/v3/scans/start', 'start', auth_token: authToken, json: data)
    end

    # Delete the specific process from the server.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/delete
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [CopyleaksDeleteRequestModel] data
    def delete(authToken, data)
      if data.nil? || !data.instance_of?(CopyleaksDeleteRequestModel)
        raise 'data is Invalid, must be instance of CopyleaksDeleteRequestModel'
      end

      verify_auth_token(authToken)

      ClientUtils.send_request(@api_client, :patch, '/v3.1/scans/delete', 'delete', auth_token: authToken, json: data)
    end

    # Resend status webhooks for existing scans.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/resend-webhook
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] scanId Copyleaks scan Id
    def resend_webhook(authToken, scanId)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)

      verify_auth_token(authToken)

      path = "/v3/scans/#{ClientUtils.escape_path(scanId)}/webhooks/resend"
      ClientUtils.send_request(@api_client, :post, path, 'resend_webhook', auth_token: authToken)
    end

    # Get current credits balance for the Copyleaks account.
    # For more info: https://docs.copyleaks.com/reference/actions/admin/check-credits
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    def get_credits_balance(authToken)
      verify_auth_token(authToken)

      ClientUtils.send_request(@api_client, :get, '/v3/scans/credits', 'get_credits_balance', auth_token: authToken)
    end

    # Export your usage history between two dates, as CSV.
    # For more info: https://docs.copyleaks.com/reference/actions/admin/usage-history
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token.
    # @param [String] startDate The start date to collect usage history from. Date Format: `dd-MM-yyyy`.
    # @param [String] endDate The end date to collect usage history from. Date Format: `dd-MM-yyyy`.
    # @yield [String] Optional. When a block is given, the CSV is streamed to it in chunks instead of
    #   being returned as one String, so a long history is never held in memory at once.
    # @return [String, nil] The usage history as CSV text, or nil when a block is given.
    def get_usages_history_csv(authToken, startDate, endDate, &block)
      raise 'startDate is Invalid, must be instance of String' if startDate.nil? || !startDate.instance_of?(String)
      raise 'endDate is Invalid, must be instance of String' if endDate.nil? || !endDate.instance_of?(String)

      verify_auth_token(authToken)

      path = "/v3/scans/usages/history?#{URI.encode_www_form(start: startDate, end: endDate)}"
      request = ClientUtils.build_request(:get, path, auth_token: authToken)

      if block
        response = @api_client.request(request) do |res|
          if Utils.is_success_status_code(res.code)
            res.read_body { |chunk| block.call(chunk.force_encoding(Encoding::UTF_8)) }
          end
        end
        return nil if Utils.is_success_status_code(response.code)
      else
        response = @api_client.request(request)
        # The endpoint returns CSV, so return the body as text.
        return response.body&.force_encoding(Encoding::UTF_8) if Utils.is_success_status_code(response.code)
      end

      handle_response(response, 'get_usages_history_csv')
    end

    # Get a list of the supported languages for OCR (this is not a list of supported languages for the api, but only for the OCR files scan).
    # For more info: https://docs.copyleaks.com/reference/actions/miscellaneous/ocr-supported-languages
    # @return [Array<String>] List of supported OCR languages.
    def get_ocr_supported_languages
      ClientUtils.send_request(@api_client, :get, '/v3/miscellaneous/ocr-languages-list', 'get_ocr_supported_languages')
    end

    # Get a list of the file types supported by plagiarism scans.
    # For more info: https://docs.copyleaks.com/reference/actions/miscellaneous/supported-plagiarism-file-types
    # @return [Hash] The supported file types, for example { 'textual' => [...], 'ocr' => [...] }.
    def get_supported_file_types
      ClientUtils.send_request(@api_client, :get, '/v3/miscellaneous/supported-plagiarism-file-types',
                               'get_supported_file_types')
    end

    # Get the file types supported by AI Text Detection. No login is needed.
    # For more info: https://docs.copyleaks.com/reference/actions/miscellaneous/supported-ai-text-detection-file-types
    # @return [Hash] For example { 'supportedAiFileTypes' => ['pdf', 'docx', ...] }.
    def get_supported_ai_text_detection_file_types
      ClientUtils.send_request(@api_client, :get, '/v3/miscellaneous/supported-ai-text-detection-file-types',
                               'get_supported_ai_text_detection_file_types')
    end

    # Get the language codes (ISO-639-1) allowed for cross-language plagiarism detection. No login is needed.
    # Use them with Copyleaks::SubmissionCrossLanguages.
    # For more info: https://docs.copyleaks.com/reference/actions/miscellaneous/supported-cross-languages
    # @return [Hash] Two maps of language name to code: the languages a scanned document can be in, and the
    #   languages results can be found in. For example
    #   { 'documentLanguages' => { 'english' => 'en', ... }, 'resultLanguages' => { 'french' => 'fr', ... } }.
    def get_allowed_cross_languages
      ClientUtils.send_request(@api_client, :get, '/v3/miscellaneous/allowed-cross-languages',
                               'get_allowed_cross_languages')
    end

    # Get a Private Cloud Hub repository's information: credit consumption, masking policy and status.
    # Requires the "Super Admin" or "Admin" role.
    # For more info: https://docs.copyleaks.com/reference/actions/private-cloud-hub/info
    # @param [CopyleaksAuthToken] authToken Copyleaks authentication token
    # @param [String] repositoryId The repository id, from the Copyleaks Admin Dashboard.
    # @return [Hash] The repository information (id, name, description, permission, status, maxCredits,
    #   currentCredits, maskingPolicy, creationTime).
    def get_repository_info(authToken, repositoryId)
      if repositoryId.nil? || !repositoryId.instance_of?(String) || repositoryId.empty?
        raise 'repositoryId is Invalid, must be a non-empty String'
      end

      verify_auth_token(authToken)

      path = "/v3/repositories/repository/#{ClientUtils.escape_path(repositoryId)}/info"
      ClientUtils.send_request(@api_client, :get, path, 'get_repository_info', auth_token: authToken)
    end

    # Get updates about Copyleaks API release notes.
    # @return [Hash] The release notes.
    def get_release_notes
      ClientUtils.send_request(@api_client, :get, '/v3/release-logs.json', 'get_release_notes')
    end

    # This method is a helper for handling response data and exceptions.
    def handle_response(response, used_by)
      Copyleaks::ClientUtils.handle_response(response, used_by)
    end
  end
end
