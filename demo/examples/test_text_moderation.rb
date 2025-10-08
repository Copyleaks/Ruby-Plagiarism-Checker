require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_text_moderation(copyleaks, authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    
    labels = [
      Copyleaks::CopyleaksTextModerationLabel.new(
        Copyleaks::CopyleaksTextModerationConstants::ADULT_V1      # label
      ),
      Copyleaks::CopyleaksTextModerationLabel.new(
        Copyleaks::CopyleaksTextModerationConstants::TOXIC_V1      # label
      ),
      Copyleaks::CopyleaksTextModerationLabel.new(
        Copyleaks::CopyleaksTextModerationConstants::VIOLENT_V1    # label
      ),
      Copyleaks::CopyleaksTextModerationLabel.new(
        Copyleaks::CopyleaksTextModerationConstants::PROFANITY_V1  # label
      ),
      Copyleaks::CopyleaksTextModerationLabel.new(
        Copyleaks::CopyleaksTextModerationConstants::SELF_HARM_V1  # label
      ),
      Copyleaks::CopyleaksTextModerationLabel.new(
        Copyleaks::CopyleaksTextModerationConstants::HARASSMENT_V1 # label
      ),
      Copyleaks::CopyleaksTextModerationLabel.new(
        Copyleaks::CopyleaksTextModerationConstants::HATE_SPEECH_V1 # label
      ),
      Copyleaks::CopyleaksTextModerationLabel.new(
        Copyleaks::CopyleaksTextModerationConstants::DRUGS_V1      # label
      ),
      Copyleaks::CopyleaksTextModerationLabel.new(
        Copyleaks::CopyleaksTextModerationConstants::FIREARMS_V1   # label
      ),
      Copyleaks::CopyleaksTextModerationLabel.new(
        Copyleaks::CopyleaksTextModerationConstants::CYBERSECURITY_V1 # label
      )
    ]
    
    text_moderation_request = Copyleaks::CopyleaksTextModerationRequestModel.new(
      text: "This is some text to scan.",                        # text
      sandbox: true,                                              # sandbox
      language: Copyleaks::CopyleaksTextModerationLanguages::ENGLISH, # language
      labels: labels                                              # labels
    )
    
    res = copyleaks.text_moderation_client.submit_text(authToken, scanId, text_moderation_request)

    response = Copyleaks::CopyleaksTextModerationResponseModel.new(  
      moderations: res['moderations'],                            # moderations
      legend: res['legend'],                                      # legend
      scanned_document: res['scannedDocument']                    # scannedDocument
    )

    logInfo('Text Moderation - submit_text', response)
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
