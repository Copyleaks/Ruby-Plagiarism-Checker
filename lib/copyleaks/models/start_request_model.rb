module Copyleaks
  class CopyleaksStartRequestModel
    attr_reader :trigger, :errorHandling

    # @param [Array<String>] trigger Ids of scans submitted for a credits check, to run as full scans.
    # @param [Integer] errorHandling See CopyleaksStartErrorHandlings.
    def initialize(trigger, errorHandling = CopyleaksStartErrorHandlings::IGNORE)
      trigger.each do |item|
        unless item.instance_of?(String)
          raise 'Copyleaks::CopyleaksStartRequestModel - trigger - entity must be of type String'
        end
      end

      unless [0, 1].include? errorHandling
        raise 'Copyleaks::CopyleaksStartRequestModel - errorHandling - errorHandling must be of type Copyleaks::CopyleaksStartErrorHandlings Consts'
      end

      @trigger = trigger
      @errorHandling = errorHandling
    end

    def as_json(*_args)
      {
        trigger: @trigger,
        errorHandling: @errorHandling
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end

  class CopyleaksStartErrorHandlings
    # Cancel the request if any scan has an error.
    CANCEL = 0
    # Start the trigger scans even if some of them have errors.
    IGNORE = 1
  end
end
