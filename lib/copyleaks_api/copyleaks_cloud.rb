require 'copyleaks_api/errors'
require 'copyleaks_api/api'

module CopyleaksApi
  class CopyleaksCloud
    ALLOWED_ENDPOINTS = [:publisher, :academic]
    attr_accessor :access_token
    attr_reader :endpoint_type

    # constructor
    def initialize(email, api_key, type)
      raise ArgumentError, "Endpoint type '#{type}' is invalid" unless ALLOWED_ENDPOINTS.include?(type.to_sym)
      @access_token = AccessToken.new(self, email, api_key)
      @endpoint_type = type
    end

    def api
      @api ||= CopyleaksApi::Api.new
    end

    # returns account balance from endpoint
    def balance
	    api.get(url('count-credits'), token: @access_token.token)['Amount'].to_i
    end

    # uses create-by-url endpoint to create process
    def create_by_url(url, options = {})
      response = api.post(url('create-by-url'), { 'Url' => url }.to_json, options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, response)
    end

    # uses create-by-file endpoint to create process
    def create_by_file(file_path, options = {})
      response = api.post_file(url('create-by-file'), file_path, options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, response)
    end

    # uses create-by-file-ocr endpoint to create process
    def create_by_ocr(ocr_file_path, options = {})
      response = api.post_file(url_with_language('create-by-file-ocr', options), ocr_file_path,
                               options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, response)
    end

    # uses create-by-text endpoint to create process
    def create_by_text(text, options = {})
      response = api.post(url('create-by-text'), text, options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, response)
    end

    # deletes process by given id
    def delete(id)
      api.delete(url(:delete, id), token: @access_token.token)
      true
    end

    # retries all processes
    def list
      response = api.get(url(:list), token: @access_token.token)
      response.map { |hash| CopyleaksProcess.create_from_list(self, hash) }
    end

    # retries status information of process with given id
    def status(id, options = {})
      response = api.get(url(:status, id), no_callbacks: true, token: @access_token.token)
      return response if options[:raw]
      CopyleaksApi::CopyleaksProcess.create_from_status(self, id, response)
    end

    # retries result information of process with given id
    def result(id, options = {})
      response = api.get(url(:result, id), no_callbacks: true, token: @access_token.token)
      return response if options[:raw]
      CopyleaksApi::CopyleaksProcess.create_from_result(self, id, response)
    end

    private

    # gather url for endpoints which need language in get parameters
    def url_with_language(action, options)
      language = options[:language] || Language.english
      Validators::LanguageValidator.validate!(language)
      url("#{action}?language=#{language}")
    end

    # gather path for endpoints
    def url(action, id = nil)
      return "#{@endpoint_type}/#{action}" if id.nil?
      "#{@endpoint_type}/#{id}/#{action}"
    end
  end
end
