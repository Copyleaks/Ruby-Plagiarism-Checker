require 'copyleaks_api/errors'
require 'copyleaks_api/api'


module CopyleaksApi
  class CopyleaksCloud
    ALLOWED_ENDPOINTS = [:businesses, :education, :websites]
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
    def get_credits_balance
	    api.get(url('count-credits'), token: @access_token.token)['Amount'].to_i
    end

    # uses create-by-url endpoint to create process
    def create_by_url(url, options = {})
      response = api.post(url('create-by-url'), { 'Url' => url }.to_json, options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, api, response)
    end

    # uses create-by-file endpoint to create process
    def create_by_file(file_path, options = {})
      response = api.post_file(url('create-by-file'), file_path, options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, api, response)
    end

    # uses create-by-file endpoint to create process
    def create_by_files(files_paths, options = {})
      response = api.post_files(url('create-by-file'), files_paths, options.merge(token: @access_token.token))
      success_uploads = response['Success']
      processes = []
      success_uploads.each do |upload|
        processes.push(CopyleaksProcess.create(self, api, upload))
      end
      processes
    end

    # uses create-by-file-ocr endpoint to create process
    def create_by_ocr(ocr_file_path, options = {})
      response = api.post_file(url_with_language('create-by-file-ocr', options), ocr_file_path,
                               options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, api, response)
    end

    # uses create-by-text endpoint to create process
    def create_by_text(text, options = {})
      response = api.post(url('create-by-text'), text, options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, api, response)
    end

    # Returns a list of your past processes
    def get_processes
      response = api.get(url(:list), token: @access_token.token)
      response.map { |hash| CopyleaksProcess.create_from_list(self, @api, hash) }
    end
    
    # Returns the raw text of a given result
    def get_raw_text(result)
      puts result.get_cached_version
      puts @access_token.token
      response = api.get_with_final_path(result.get_cached_version, token: @access_token.token)
      puts response
    end

    # Returns the raw text of a given result
    def get_comparison_report(result)
      response = api.get_with_final_path(result.get_comparison_report, token: @access_token.token)
    end
    
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
