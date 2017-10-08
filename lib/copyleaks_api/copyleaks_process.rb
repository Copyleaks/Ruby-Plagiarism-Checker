require 'time'
require 'copyleaks_api/Models/ResultRecord'


module CopyleaksApi
  class CopyleaksProcess
    attr_accessor :process_id, :progress, :custom_fields, :created_at

    # constructor
    def initialize(options)
      @cloud = options[:cloud]
      [:cloud, :api, :process_id, :custom_fields, :result, :progress].each do |attr|
        instance_variable_set("@#{attr}", options[attr]) if options[attr]
      end
      @created_at = DateTime.parse(options[:created_at]) if options[:created_at]
    end
    
    def to_s
      return "Created at: #{@created_at}"
    end

    # returns true if still processing data on server side
    def processing?
      if @progress == 100
        false
      else
        true
      end
    end

    # return result data or retrieves from result endpoint if nothing specified
    # retries result information of process with given id
    def get_results
      response = @api.get(@cloud.url(:result, @process_id), no_callbacks: true, token: @cloud.access_token.token)
      @results = []
      response.each do |res|
        @results.push(CopyleaksApi::ResultRecord.new(res))
      end
      @results
    end
    
    # retries status information of process with given id
    def update_status
      response = @api.get(@cloud.url(:status, @process_id), no_callbacks: true, token: @cloud.access_token.token)
      @progress = response['ProgressPercents'].to_i
      @progress
    end

    # Returns the source text of this process
    def get_source_text
      response = @api.get(@cloud.url_downloads("source-text?pid=#{@process_id}"), parse_json: false, no_callbacks: true, token: @cloud.access_token.token)
      response
    end

    # deletes process from API
    def delete
      response = @api.delete(@cloud.url(:delete, @process_id), token: @cloud.access_token.token)
      if response['StatusCode'] == 200
        true
      else
        false
      end
    end

    class << self
      # create CopyleaksProcess based on data got from any create endpoint
      def create(cloud, api, hash)
        new(cloud: cloud, api: api, process_id: hash['ProcessId'], created_at: hash['CreationTimeUTC'])
      end
    
      # creates CopyleaksProcess based on data got from list endpoint
      def create_from_list(cloud, api, hash)
        new(cloud: cloud, api: api, process_id: hash['ProcessId'], created_at: hash['CreationTimeUTC'],
            status_code: hash['Status'].downcase, custom_fields: hash['CustomFields'])
      end
    end
  end
end
