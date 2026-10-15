require_relative  './repository.rb'

module Copyleaks
    class SubmissionIndexingRepository < SubmissionRepository
      # @param [String] id Repository to add the scanned document to.
      # @param [SubmissionMaskingPolicy] maskingPolicy
      def initialize(id, maskingPolicy = nil)
        super(id)
        if !maskingPolicy.nil? && ![0, 1, 2].include?(maskingPolicy)
            raise 'Copyleaks::SubmissionIndexingRepository - maskingPolicy - maskingPolicy must be of type SubmissionMaskingPolicy'
        end
        @maskingPolicy = maskingPolicy
      end
  
      def as_json(*_args)
        {
            id: @id,
            maskingPolicy: @maskingPolicy,
        }.select { |_k, v| !v.nil? }
      end
  
      def to_json(*options)
        as_json(*options).to_json(*options)
      end
    end
  end
