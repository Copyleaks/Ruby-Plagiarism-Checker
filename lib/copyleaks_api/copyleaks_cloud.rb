require 'copyleaks_api/errors'
require 'copyleaks_api/api'

module CopyleaksApi
  class CopyleaksCloud
    attr_accessor :access_token

    def initialize(email, api_key)
      @access_token = AccessToken.new(email, api_key)
    end

    def balance
      API.get('account/count-credits', token: @access_token.token)['Amount'].to_i
    end

    def create_by_url(url, options = {})
      response = API.post(url('create-by-url'), { 'Url' => url }.to_json, options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, response)
    end

    def create_by_file(file_path, options = {})
      response = API.post_file(url('create-by-file'), file_path, options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, response)
    end

    def create_by_ocr(ocr_file_path, options = {})
      response = API.post_file(url_with_language('create-by-file-ocr', options), ocr_file_path,
                               options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, response)
    end

    def create_by_text(text, options = {})
      response = API.post(url('create-by-text'), text, options.merge(token: @access_token.token))
      CopyleaksProcess.create(self, response)
    end

    def delete(id)
      API.delete(url(:delete, id), token: @access_token.token)
      true
    end

    def list
      response = API.get(url(:list), token: @access_token.token)
      response.map { |hash| CopyleaksProcess.create_from_list(self, hash) }
    end

    def status(id, options = {})
      response = API.get(url(:status, id), no_callbacks: true, token: @access_token.token)
      return response if options[:raw]
      CopyleaksApi::CopyleaksProcess.create_from_status(self, id, response)
    end

    def result(id, options = {})
      response = API.get(url(:result, id), no_callbacks: true, token: @access_token.token)
      return response if options[:raw]
      CopyleaksApi::CopyleaksProcess.create_from_result(self, id, response)
    end

    private

    def url_with_language(action, options)
      language = options[:language] || Language.english
      Validators::LanguageValidator.validate!(language)
      url("#{action}?language=#{language}")
    end

    def url(action, id = nil)
      return "publisher/#{action}" if id.nil?
      "publisher/#{id}/#{action}"
    end
  end
end
