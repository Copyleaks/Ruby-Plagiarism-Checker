require_relative 'enable_flag.rb'

module Copyleaks
  # Find sources in the Copyleaks internal AI database that contain AI-generated text, reported in
  # results.internalAIData of the completed webhook.
  class SubmissionInternalAiSourceMatch < SubmissionEnableFlag; end
end
