module Copyleaks
  class SubmissionScanningCopyleaksDB
    # Arguments left nil are not sent. Either flag set to true also indexes the scan in the internal database.
    # @param [Boolean] includeMySubmissions Also compare against content YOU uploaded to the internal database.
    # @param [Boolean] includeOthersSubmissions Also compare against content OTHERS uploaded to the internal database.
    def initialize(includeMySubmissions = nil, includeOthersSubmissions = nil)
      @includeMySubmissions = includeMySubmissions
      @includeOthersSubmissions = includeOthersSubmissions
    end

    def as_json(*_args)
      {
        includeMySubmissions: @includeMySubmissions,
        includeOthersSubmissions: @includeOthersSubmissions
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
