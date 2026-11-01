module Copyleaks
  # Gen-AI Overview: key insights from the scan data. Fields left nil are not sent (server default: false).
  # The ignore* flags leave AI detection, plagiarism, the Grammar Checker or the author's history out of it.
  class SubmissionOverview
    attr_reader :enable, :ignoreAIDetection, :ignorePlagiarismDetection, :ignoreWritingFeedback, :ignoreAuthorData

    def initialize(enable = nil, ignoreAIDetection: nil, ignorePlagiarismDetection: nil, ignoreWritingFeedback: nil,
                   ignoreAuthorData: nil)
      {
        enable: enable,
        ignoreAIDetection: ignoreAIDetection,
        ignorePlagiarismDetection: ignorePlagiarismDetection,
        ignoreWritingFeedback: ignoreWritingFeedback,
        ignoreAuthorData: ignoreAuthorData
      }.each do |name, value|
        if !value.nil? && ![true, false].include?(value)
          raise "Copyleaks::SubmissionOverview - #{name} - #{name} must be of type Boolean"
        end
      end

      @enable = enable
      @ignoreAIDetection = ignoreAIDetection
      @ignorePlagiarismDetection = ignorePlagiarismDetection
      @ignoreWritingFeedback = ignoreWritingFeedback
      @ignoreAuthorData = ignoreAuthorData
    end

    def as_json(*_args)
      {
        enable: @enable,
        ignoreAIDetection: @ignoreAIDetection,
        ignorePlagiarismDetection: @ignorePlagiarismDetection,
        ignoreWritingFeedback: @ignoreWritingFeedback,
        ignoreAuthorData: @ignoreAuthorData
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
