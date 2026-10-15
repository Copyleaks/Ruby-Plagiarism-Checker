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
  # Entry point of the SDK. Thread-safe; keeps a small pool of persistent connections per server.
  #
  # Errors raised by every call:
  # * CommandException: request rejected; exception.response has the status code, headers and body.
  # * UnderMaintenanceException (HTTP 503) and RateLimitException (HTTP 429, see exception.retry_after).
  # * AuthExpiredException: the login token has expired; log in again.
  # * Net::OpenTimeout, Net::ReadTimeout, Net::WriteTimeout, socket errors. Requests are never resent
  #   automatically. A timed-out submit may have been accepted: resubmitting its scan id returns 409 Conflict.
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
      @id_client = HttpClient.new(identity_server_uri || Config.identity_server_uri, **options)
      @api_client = HttpClient.new(api_server_uri || Config.api_server_uri, **options)

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

    # Logs in to the Copyleaks identity server.
    # For more info: https://docs.copyleaks.com/reference/actions/account/login
    # @param [String] key Account secret key.
    # @return [CopyleaksAuthToken] Expires; see #verify_auth_token.
    def login(email, key)
      raise 'email is Invalid, must be instance of String' if email.nil? || !email.instance_of?(String)
      raise 'key is Invalid, must be instance of String' if key.nil? || !key.instance_of?(String)

      payload = { email: email, key: key }
      res_data = ClientUtils.send_request(@id_client, :post, '/v3/account/login/api', 'login', json: payload)

      CopyleaksAuthToken.new(res_data['.expires'], res_data['access_token'], res_data['.issued'])
    end

    # Raises AuthExpiredException when the token has expired or expires within the next 5 minutes.
    def verify_auth_token(authToken)
      ClientUtils.verify_auth_token(authToken)
    end

    # Starts a scan of a file, given as a CopyleaksFileSubmissionModel.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/submit-file
    def submit_file(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(CopyleaksFileSubmissionModel)
        raise 'submission is Invalid, must be instance of type CopyleaksFileSubmissionModel'
      end

      verify_auth_token(authToken)

      path = "/v3/scans/submit/file/#{ClientUtils.escape_path(scanId)}"
      ClientUtils.send_request(@api_client, :put, path, 'submit_file', auth_token: authToken, json: submission)
    end

    # Starts an OCR scan of an image file, given as a CopyleaksFileOcrSubmissionModel.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/submit-ocr
    def submit_file_ocr(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(CopyleaksFileOcrSubmissionModel)
        raise 'submission is Invalid, must be instance of type CopyleaksFileOcrSubmissionModel'
      end

      verify_auth_token(authToken)

      path = "/v3/scans/submit/ocr/#{ClientUtils.escape_path(scanId)}"
      ClientUtils.send_request(@api_client, :put, path, 'submit_file_ocr', auth_token: authToken, json: submission)
    end

    # Starts a scan of a URL, given as a CopyleaksURLSubmissionModel.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/submit-url
    def submit_url(authToken, scanId, submission)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)
      if submission.nil? || !submission.instance_of?(CopyleaksURLSubmissionModel)
        raise 'submission is Invalid, must be instance of CopyleaksURLSubmissionModel'
      end

      verify_auth_token(authToken)

      path = "/v3/scans/submit/url/#{ClientUtils.escape_path(scanId)}"
      ClientUtils.send_request(@api_client, :put, path, 'submit_url', auth_token: authToken, json: submission)
    end

    # Exports a scan's artifacts to your server.
    # For more info: https://docs.copyleaks.com/reference/actions/downloads/export
    # @param [String] exportId A new id for this export.
    # @param [CopyleaksExportModel] model Which artifacts to export, and where.
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

    # Starts scans that were submitted for a price check; data is a CopyleaksStartRequestModel.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/start
    def start(authToken, data)
      if data.nil? || !data.instance_of?(CopyleaksStartRequestModel)
        raise 'data is Invalid, must be instance of type CopyleaksStartRequestModel'
      end

      verify_auth_token(authToken)

      ClientUtils.send_request(@api_client, :patch, '/v3/scans/start', 'start', auth_token: authToken, json: data)
    end

    # Deletes scans; data is a CopyleaksDeleteRequestModel.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/delete
    def delete(authToken, data)
      if data.nil? || !data.instance_of?(CopyleaksDeleteRequestModel)
        raise 'data is Invalid, must be instance of CopyleaksDeleteRequestModel'
      end

      verify_auth_token(authToken)

      ClientUtils.send_request(@api_client, :patch, '/v3.1/scans/delete', 'delete', auth_token: authToken, json: data)
    end

    # Resends the status webhooks of an existing scan.
    # For more info: https://docs.copyleaks.com/reference/actions/authenticity/resend-webhook
    def resend_webhook(authToken, scanId)
      raise 'scanId is Invalid, must be instance of String' if scanId.nil? || !scanId.instance_of?(String)

      verify_auth_token(authToken)

      path = "/v3/scans/#{ClientUtils.escape_path(scanId)}/webhooks/resend"
      ClientUtils.send_request(@api_client, :post, path, 'resend_webhook', auth_token: authToken)
    end

    # Returns the account's credit balance.
    # For more info: https://docs.copyleaks.com/reference/actions/admin/check-credits
    def get_credits_balance(authToken)
      verify_auth_token(authToken)

      ClientUtils.send_request(@api_client, :get, '/v3/scans/credits', 'get_credits_balance', auth_token: authToken)
    end

    # Returns the usage history between two dates as CSV.
    # For more info: https://docs.copyleaks.com/reference/actions/admin/usage-history
    # @param [String] startDate `dd-MM-yyyy`.
    # @param [String] endDate `dd-MM-yyyy`.
    # @yield [String] Optional. Streams the CSV in chunks, so a long history is never held in memory.
    # @return [String, nil] The CSV text, or nil when a block is given.
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

    # Lists the languages supported by OCR file scans (not by the API in general).
    # For more info: https://docs.copyleaks.com/reference/actions/miscellaneous/ocr-supported-languages
    # @return [Array<String>]
    def get_ocr_supported_languages
      ClientUtils.send_request(@api_client, :get, '/v3/miscellaneous/ocr-languages-list', 'get_ocr_supported_languages')
    end

    # Lists the file types supported by plagiarism scans.
    # For more info: https://docs.copyleaks.com/reference/actions/miscellaneous/supported-plagiarism-file-types
    # @return [Hash] For example { 'textual' => [...], 'ocr' => [...] }.
    def get_supported_file_types
      ClientUtils.send_request(@api_client, :get, '/v3/miscellaneous/supported-plagiarism-file-types',
                               'get_supported_file_types')
    end

    # Lists the file types supported by AI Text Detection. No login is needed.
    # For more info: https://docs.copyleaks.com/reference/actions/miscellaneous/supported-ai-text-detection-file-types
    # @return [Hash] For example { 'supportedAiFileTypes' => ['pdf', 'docx', ...] }.
    def get_supported_ai_text_detection_file_types
      ClientUtils.send_request(@api_client, :get, '/v3/miscellaneous/supported-ai-text-detection-file-types',
                               'get_supported_ai_text_detection_file_types')
    end

    # Lists the ISO-639-1 codes for Copyleaks::SubmissionCrossLanguages. No login is needed.
    # For more info: https://docs.copyleaks.com/reference/actions/miscellaneous/supported-cross-languages
    # @return [Hash] Name-to-code maps for scanned documents and for results, for example
    #   { 'documentLanguages' => { 'english' => 'en', ... }, 'resultLanguages' => { 'french' => 'fr', ... } }.
    def get_allowed_cross_languages
      ClientUtils.send_request(@api_client, :get, '/v3/miscellaneous/allowed-cross-languages',
                               'get_allowed_cross_languages')
    end

    # Returns a Private Cloud Hub repository's credits, masking policy and status. Needs the Admin or Super Admin role.
    # For more info: https://docs.copyleaks.com/reference/actions/private-cloud-hub/info
    # @param [String] repositoryId From the Copyleaks Admin Dashboard.
    def get_repository_info(authToken, repositoryId)
      if repositoryId.nil? || !repositoryId.instance_of?(String) || repositoryId.empty?
        raise 'repositoryId is Invalid, must be a non-empty String'
      end

      verify_auth_token(authToken)

      path = "/v3/repositories/repository/#{ClientUtils.escape_path(repositoryId)}/info"
      ClientUtils.send_request(@api_client, :get, path, 'get_repository_info', auth_token: authToken)
    end

    # Returns the Copyleaks API release notes.
    def get_release_notes
      ClientUtils.send_request(@api_client, :get, '/v3/release-logs.json', 'get_release_notes')
    end

    # Returns the parsed JSON body (nil when empty), or raises the matching exception for a failed response.
    def handle_response(response, used_by)
      Copyleaks::ClientUtils.handle_response(response, used_by)
    end
  end
end
