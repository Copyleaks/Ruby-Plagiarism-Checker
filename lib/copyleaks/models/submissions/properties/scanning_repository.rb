module Copyleaks
  class SubmissionScanningRepository < SubmissionRepository
    # @param [Boolean] includeMySubmissions Compare against MY submissions in the repository.
    # @param [Boolean] includeOthersSubmissions Compare against OTHER users' submissions in the repository.
    def initialize(id, includeMySubmissions, includeOthersSubmissions)
      super(id)
      @includeMySubmissions = includeMySubmissions
      @includeOthersSubmissions = includeOthersSubmissions
    end

    def as_json(*_args)
      {
        id: @id,
        includeMySubmissions: @includeMySubmissions,
        includeOthersSubmissions: @includeOthersSubmissions
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
