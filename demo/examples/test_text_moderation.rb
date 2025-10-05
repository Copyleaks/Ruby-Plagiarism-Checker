require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_text_moderation(copyleaks, authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    labelsArray=[
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::ADULT_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::TOXIC_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::VIOLENT_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::PROFANITY_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::SELF_HARM_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::HARASSMENT_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::HATE_SPEECH_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::DRUGS_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::FIREARMS_V1),
      Copyleaks::CopyleaksTextModerationLabel.new(Copyleaks::CopyleaksTextModerationConstants::CYBERSECURITY_V1)
    ]
    
    text_moderation_request = Copyleaks::CopyleaksTextModerationRequestModel.new(
      text: "This is some text to scan.",
      sandbox: true,
      language: Copyleaks::CopyleaksTextModerationLanguages::ENGLISH,
      labels: labelsArray
    )
    res = copyleaks.text_moderation_client.submit_text(authToken, scanId, text_moderation_request)

    textModerationResponse = Copyleaks::CopyleaksTextModerationResponseModel.new(  
      moderations: res['moderations'],
      legend: res['legend'],
      scanned_document: res['scannedDocument'])

    logInfo('Text Moderation - submit_text', textModerationResponse)
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
