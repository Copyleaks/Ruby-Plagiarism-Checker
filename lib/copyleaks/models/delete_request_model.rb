require 'json'
module Copyleaks
  class CopyleaksDeleteRequestModel
    attr_reader :scans, :purge, :completionWebhook, :headers

    # @param [Array] scans IdObject items.
    # @param [Boolean] purge Remove every trace of the scans, including from the internal database, so they are no
    #   longer found as results of other scans. Server default: false.
    # @param [String] completionWebhook Called with a POST and no body once the deletion is complete.
    # @param [Array<Array<String>>] headers For the completion webhook, e.g. [['Authorization', 'Bearer my-token']].
    def initialize(scans, purge = nil, completionWebhook = nil, headers: nil)
      scans.each do |object_id|
        unless object_id.instance_of?(IdObject)
          raise 'Copyleaks::CopyleaksDeleteRequestModel - scans - entity must be of type Copyleaks::IdObject'
        end
      end

      unless purge.nil? || [true, false].include?(purge)
        raise 'Copyleaks::CopyleaksDeleteRequestModel - purge - purge must be of type Boolean'
      end

      unless completionWebhook.nil? || completionWebhook.instance_of?(String)
        raise 'Copyleaks::CopyleaksDeleteRequestModel - completionWebhook - completionWebhook must be of type String'
      end

      unless headers.nil? || (headers.instance_of?(Array) && headers.all? { |pair| pair.instance_of?(Array) && pair.length == 2 && pair.all? { |part| part.instance_of?(String) } })
        raise 'Copyleaks::CopyleaksDeleteRequestModel - headers - headers must be an Array of String Array pairs'
      end

      @scans = scans
      @purge = purge
      # An empty webhook URL means "no webhook": leave it out of the request.
      @completionWebhook = completionWebhook == '' ? nil : completionWebhook
      @headers = headers
    end

    def as_json(*_args)
      {
        scans: @scans.map { |object_id| object_id.as_json },
        purge: @purge,
        completionWebhook: @completionWebhook,
        headers: @headers
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
