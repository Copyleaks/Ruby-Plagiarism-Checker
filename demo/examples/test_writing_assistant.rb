require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_writing_assistant(copyleaks, authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    
    score_weights = Copyleaks::ScoreWeights.new(
      0.1,                                                      # grammarWeight
      0.2,                                                      # mechanicsWeight
      0.3,                                                      # sentenceStructureWeight
      0.4                                                       # wordChoiceWeight
    )
    
    submission = Copyleaks::WritingAssistantSubmissionModel.new(
      "Lions are the only cat that live in groups, called pride. A prides typically consists of a few adult males, several feales, and their offspring. This social structure is essential for hunting and raising young cubs. Female lions, or lionesses are the primary hunters of the prid. They work together in cordinated groups to take down prey usually targeting large herbiores like zbras, wildebeest and buffalo. Their teamwork and strategy during hunts highlight the intelligence and coperation that are key to their survival."  # text
    )
    submission.sandbox = true
    submission.score = score_weights
    
    res = copyleaks.writing_assistant_client.submit_text(authToken, scanId, submission)
    logInfo('Writing Assistant - submit_text', res)
  end

  def self.logInfo(title, info = nil)
    puts '-------------' + title + '-------------'
    puts info.to_json unless info.nil?
    puts
  rescue StandardError => e
    puts info.inspect unless info.nil?
    puts
  end
end
