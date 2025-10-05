require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_ai_detection_natural_language(copyleaks, authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    text = "Lions are social animals, living in groups called prides, typically consisting of several females, their offspring, and a few males. Female lions are the primary hunters, working together to catch prey. Lions are known for their strength, teamwork, and complex social structures."
    submission = Copyleaks::NaturalLanguageSubmissionModel.new(
      text,
    )
    submission.sandbox = true
    
    res = copyleaks.ai_detection_client.submit_natural_language(authToken, scanId, submission)
    logInfo('AI Detection - submit_natural_language', res)
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
