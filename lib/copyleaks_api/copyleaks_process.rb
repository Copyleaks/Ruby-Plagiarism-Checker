require 'time'

module CopyleaksApi
  class CopyleaksProcess
    STATUSES = ['processing', 'ready', 'allocated', 'finished', 'error', 'deleted'].freeze

    attr_accessor :status, :process_id, :status, :progress, :custom_fields, :created_at

    # constructor
    def initialize(options)
      @cloud = options[:cloud]
      [:cloud, :process_id, :custom_fields, :result, :status, :progress].each do |attr|
        instance_variable_set("@#{attr}", options[attr]) if options[attr]
      end

      @created_at = DateTime.parse(options[:created_at]) if options[:created_at]
      @status = STATUSES[options[:status_code].to_i + 1] if options[:status_code]
    end

    STATUSES[1..-1].each do |status|
      # predicate methods for all statuses
      define_method("#{status}?") do
        reload if @status.nil?
        @status == status
      end
    end

    # returns true if process status means processing data on server side
    def processing?
      ['ready', 'allocated', 'processing'].include?(@status)
    end

    # return result data or retrieves from result endpoint if nothing specified
    def result
      @result ||= @cloud.result(process_id, raw: true)
    end

    # returns status information or reload if no data is specified
    def status
      reload if @status.nil?
      @status
    end

    # deletes process from API
    def delete
      @cloud.delete(process_id)
      @status = 'deleted'
    end

    # reload object attributes using status endpoint
    def reload
      response = @cloud.status(process_id, raw: true)
      @status = response['Status'].downcase
      @progress = response['ProgressPercents'].to_i
      @result = nil
      self
    end

    class << self
      # create CopyleaksProcess based on data got from any create endpoint
      def create(cloud, hash)
        new(cloud: cloud, process_id: hash['ProcessId'], created_at: hash['CreationTimeUTC'])
      end

      # create CopyleaksProcess based on data got from status endpoint
      def create_from_status(cloud, id, hash)
        new(cloud: cloud, process_id: id, status: hash['Status'].downcase, progress: hash['ProgressPercents'])
      end

      # creates CopyleaksProcess based on data got from result endpoint
      def create_from_result(cloud, id, result)
        new(cloud: cloud, process_id: id, result: result)
      end

      # creates CopyleaksProcess based on data got from list endpoint
      def create_from_list(cloud, hash)
        new(cloud: cloud, process_id: hash['ProcessId'], created_at: hash['CreationTimeUTC'],
            status: hash['Status'].downcase, custom_fields: hash['CustomFields'])
      end
    end
  end
end
