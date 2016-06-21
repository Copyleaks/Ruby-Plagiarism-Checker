require 'time'

module CopyleaksApi
  class CopyleaksProcess
    STATUSES = ['processing', 'ready', 'allocated', 'finished', 'error', 'deleted'].freeze

    attr_accessor :status, :process_id, :status, :progress, :custom_fields, :created_at

    def initialize(options)
      @cloud = options[:cloud]
      [:cloud, :process_id, :custom_fields, :result, :status, :progress].each do |attr|
        instance_variable_set("@#{attr}", options[attr]) if options[attr]
      end

      @created_at = DateTime.parse(options[:created_at]) if options[:created_at]
      @status = STATUSES[options[:status_code].to_i + 1] if options[:status_code]
    end

    STATUSES[1..-1].each do |status|
      define_method("#{status}?") do
        reload if @status.nil?
        @status == status
      end
    end

    def processing?
      ['ready', 'allocated', 'processing'].include?(@status)
    end

    def result
      @result ||= @cloud.result(process_id, raw: true)
    end

    def status
      reload if @status.nil?
      @status
    end

    def delete
      @cloud.delete(process_id)
      @status = 'deleted'
    end

    def reload
      response = @cloud.status(process_id, raw: true)
      @status = response['Status'].downcase
      @progress = response['ProgressPercents'].to_i
      @result = nil
      self
    end

    class << self
      def create(cloud, hash)
        new(cloud: cloud, process_id: hash['ProcessId'], created_at: hash['CreationTimeUTC'])
      end

      def create_from_status(cloud, id, hash)
        new(cloud: cloud, process_id: id, status: hash['Status'].downcase, progress: hash['ProgressPercents'])
      end

      def create_from_result(cloud, id, result)
        new(cloud: cloud, process_id: id, result: result)
      end

      def create_from_list(cloud, hash)
        new(cloud: cloud, process_id: hash['ProcessId'], created_at: hash['CreationTimeUTC'],
            status: hash['Status'].downcase, custom_fields: hash['CustomFields'])
      end
    end
  end
end
