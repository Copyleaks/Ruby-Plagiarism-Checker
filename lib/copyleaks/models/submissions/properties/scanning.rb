module Copyleaks
  class SubmissionScanning
    # Arguments left nil are not sent, so the server default applies.
    # @param [Boolean] internet Compare with online sources (server default: true).
    # @param [SubmissionCrossLanguages] crossLanguages Languages for cross-language plagiarism detection.
    def initialize(
      internet = nil,
      exclude = nil,
      repositories = nil,
      copyleaksDb = nil,
      crossLanguages = nil,
      include: nil
    )
      if !internet.nil? && ![true, false].include?(internet)
        raise 'Copyleaks::SubmissionScanning - internet - internet must be of type Boolean'
      end
      if !include.nil? && !include.instance_of?(SubmissionScanningInclude)
        raise 'Copyleaks::SubmissionScanning - include - include must be of type SubmissionScanningInclude'
      end

      @internet = internet
      @exclude = exclude
      @repositories = repositories
      @copyleaksDb = copyleaksDb
      @crossLanguages = crossLanguages
      @include = include
    end

    def as_json(*_args)
      {
        internet: @internet,
        exclude: @exclude,
        include: @include,
        repositories: @repositories,
        copyleaksDb: @copyleaksDb,
        crossLanguages: @crossLanguages
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
