require_relative '../lib/index'
require 'json'
require 'date'
require_relative 'base64logo.rb'
require_relative './webhookServer'
module CopyleaksDemo
  USER_EMAIL = '<YOUR EMAIL>'
  USER_API_KEY = '<YOUR KEY>'
  WEBHOOK_URL = '<WEBHOOK URL>'

  # Start the webhook server in a background thread
  puts "Starting webhook server..."
  WebhookServer.start
  
  def self.run
    @copyleaks = Copyleaks::API.new    
    # test_misc

    loginResponse = @copyleaks.login(USER_EMAIL, USER_API_KEY)
    logInfo('login', loginResponse)

    @copyleaks.verify_auth_token(loginResponse)

    # test_credit_balance(loginResponse)

    # test_usages_history(loginResponse)

    # test_delete(loginResponse)

    # test_resend_webhook(loginResponse)

    # test_export(loginResponse)

    # test_start(loginResponse)

    # test_submit_url(loginResponse)

    test_submit_file(loginResponse)

    # test_submit_ocr_file(loginResponse)

    # test_ai_detection_natural_language(loginResponse)

    # test_ai_detection_source_code(loginResponse)

    # test_writing_assistant(loginResponse)

    test_text_moderation(loginResponse)
  rescue StandardError => e
    puts '--------ERROR-------'
    puts
    puts e.message
    puts
    puts '--------------------'
  end

  def self.test_submit_ocr_file(_authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    submisson = Copyleaks::CopyleaksFileOcrSubmissionModel.new(
      'en',
      'aGVsbG8gd29ybGQ=',
      'ruby.txt',
      Copyleaks::SubmissionProperties.new(
        Copyleaks::SubmissionWebhooks.new("#{WEBHOOK_URL}/url-webhook/scan/#{scanId}/{STATUS}"),
        true,
        'developer_payloads_test',
        true,
        60,
        1,
        true,
        Copyleaks::SubmissionActions::SCAN,
        Copyleaks::SubmissionAuthor.new('Author_name'),
        Copyleaks::SubmissionFilter.new(true, true, true),
        Copyleaks::SubmissionScanning.new(true, nil, nil, Copyleaks::SubmissionScanningCopyleaksDB.new(true, true)),
        Copyleaks::SubmissionIndexing.new([Copyleaks::SubmissionRepository.new('repo-1')]),
        Copyleaks::SubmissionExclude.new(true, true, true, true, true),
        Copyleaks::SubmissionPDF.new(true, 'pdf-title', BASE64_LOGO, false),
        Copyleaks::SubmissionSensitiveData.new(false)
      )
    )

    @copyleaks.submit_file_ocr(_authToken, scanId, submisson)
    logInfo('submit_file_ocr')
  end

  def self.test_submit_file(_authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    submisson = Copyleaks::CopyleaksFileSubmissionModel.new(
      'aGVsbG8gd29ybGQ=',
      'ruby.txt',
      Copyleaks::SubmissionProperties.new(
        Copyleaks::SubmissionWebhooks.new("#{WEBHOOK_URL}/url-webhook/scan/#{scanId}/{STATUS}","#{WEBHOOK_URL}/url-webhook/new-result"),
        true,
        'developer_payloads_test',
        true,
        60,
        1,
        true,
        Copyleaks::SubmissionActions::SCAN,
        Copyleaks::SubmissionAuthor.new('Author_name'),
        Copyleaks::SubmissionFilter.new(true, true, true),
        Copyleaks::SubmissionScanning.new(true, nil, nil, Copyleaks::SubmissionScanningCopyleaksDB.new(true, true)),
        Copyleaks::SubmissionIndexing.new([Copyleaks::SubmissionRepository.new('repo-1')]),
        Copyleaks::SubmissionExclude.new(true, true, true, true, true),
        Copyleaks::SubmissionPDF.new(true, 'pdf-title', BASE64_LOGO, false),
        Copyleaks::SubmissionSensitiveData.new(false)
      )
    )

    @copyleaks.submit_file(_authToken, scanId, submisson)
    logInfo('submit_file')
  end

  def self.test_submit_url(_authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    submisson = Copyleaks::CopyleaksURLSubmissionModel.new(
      'https://copyleaks.com',
      Copyleaks::SubmissionProperties.new(
        Copyleaks::SubmissionWebhooks.new("#{WEBHOOK_URL}/url-webhook/scan/#{scanId}/{STATUS}"),
        true,
        'developer_payloads_test',
        true,
        60,
        1,
        true,
        Copyleaks::SubmissionActions::SCAN,
        Copyleaks::SubmissionAuthor.new('Author_name'),
        Copyleaks::SubmissionFilter.new(true, true, true),
        Copyleaks::SubmissionScanning.new(true, nil, nil, Copyleaks::SubmissionScanningCopyleaksDB.new(true, true)),
        Copyleaks::SubmissionIndexing.new([Copyleaks::SubmissionRepository.new('repo-1')]),
        Copyleaks::SubmissionExclude.new(true, true, true, true, true),
        Copyleaks::SubmissionPDF.new(true, 'pdf-title', BASE64_LOGO, false),
        Copyleaks::SubmissionSensitiveData.new(false)
      )
    )

    @copyleaks.submit_url(_authToken, scanId, submisson)
    logInfo('submit_url')
  end

  def self.test_start(_authToken)
    data = Copyleaks::CopyleaksStartRequestModel.new(['1611225876017'],
                                                     Copyleaks::CopyleaksStartErrorHandlings::IGNORE)
    @copyleaks.start(_authToken, data)
    logInfo('start')
  end

  def self.test_export(authToken)
    scanId = '1611042641'
    model = Copyleaks::CopyleaksExportModel.new(
      "#{WEBHOOK_URL}/export/#{scanId}",
      [
        Copyleaks::ExportResults.new('2a1b402420', "#{WEBHOOK_URL}/export/#{scanId}/result/2a1b402420", 'POST',
                                     [%w[key1 value1], %w[key2 value2]])
      ],
      Copyleaks::ExportCrawledVersion.new("#{WEBHOOK_URL}/export/#{scanId}/crawled-version", 'POST')
    )

    @copyleaks.export(authToken, scanId, scanId, model)
    logInfo('export')
  end

  def self.test_resend_webhook(authToken)
    @copyleaks.resend_webhook(authToken, 'gzs55hrpefsaplcp')
    logInfo('resend_webhook')
  end

  def self.test_delete(authToken)
    model = Copyleaks::CopyleaksDeleteRequestModel.new(
      [
        Copyleaks::IdObject.new('e39awrk3829v3x3x')
      ],
      true,
      "#{WEBHOOK_URL}/delete"
    )
    @copyleaks.delete(authToken, model)
    logInfo('delete')
  end

  def self.test_usages_history(authToken)
    res = @copyleaks.get_usages_history_csv(authToken, '01-01-2021', '02-02-2021')
    logInfo('get_usages_history_csv', res)
  end

  def self.test_credit_balance(authToken)
    res = @copyleaks.get_credits_balance(authToken)
    logInfo('get_credits_balance', res)
  end

  def self.test_misc
    ocr_supported_languages = @copyleaks.get_ocr_supported_languages
    logInfo('get_ocr_supported_languages', ocr_supported_languages)

    supported_file_types = @copyleaks.get_supported_file_types
    logInfo('get_supported_file_types', supported_file_types)

    release_notes = @copyleaks.get_release_notes
    logInfo('get_release_notes', release_notes)
  end

  def self.test_ai_detection_natural_language(_authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    text = "Lions are social animals, living in groups called prides, typically consisting of several females, their offspring, and a few males. Female lions are the primary hunters, working together to catch prey. Lions are known for their strength, teamwork, and complex social structures."
    submission = Copyleaks::NaturalLanguageSubmissionModel.new(
      text,
    )
    submission.sandbox = true
    
    res = @copyleaks.ai_detection_client.submit_natural_language(_authToken, scanId, submission)
    logInfo('AI Detection - submit_natural_language', res)
  end

  def self.test_ai_detection_source_code(_authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    sample_code = 
    """def add(a, b):
        return a + b

      def multiply(a, b):
          return a * b

      def main():
          x = 5
          y = 10
          sum_result = add(x, y)
          product_result = multiply(x, y)
          print(f'Sum: {sum_result}')
          print(f'Product: {product_result}')

      if __name__ == '__main__':
          main()"""
      submission = Copyleaks::SourceCodeSubmissionModel.new(
        sample_code,
        "sample.py"
      )
      submission.sandbox = true
    res = @copyleaks.ai_detection_client.submit_source_code(_authToken, scanId, submission)
    logInfo('AI Detection - submit_source_code', res)
  end

  def self.test_writing_assistant(_authToken)
    text = "Lions are the only cat that live in groups, called pride. A prides typically consists of a few adult males, several feales, and their offspring. This social structure is essential for hunting and raising young cubs. Female lions, or lionesses are the primary hunters of the prid. They work together in cordinated groups to take down prey usually targeting large herbiores like zbras, wildebeest and buffalo. Their teamwork and strategy during hunts highlight the intelligence and coperation that are key to their survival."
    scanId = DateTime.now.strftime('%Q').to_s
    score_weights = Copyleaks::ScoreWeights.new(0.1, 0.2, 0.3, 0.4)
    submission = Copyleaks::WritingAssistantSubmissionModel.new(
      text,
    )
    submission.sandbox = true
    submission.score = score_weights
    res = @copyleaks.writing_assistant_client.submit_text(_authToken, scanId, submission)
    logInfo('Writing Assistant - submit_text', res)
  end

  def self.test_text_moderation(_authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    text_moderation_request = CopyleaksTextModerationRequestModel.new(
      text: "This is a sample text for moderation.",  # text
      sandbox: true,                                  # sandbox mode (optional, defaults to false)
      language: "en",                                 # language (optional, can be nil for auto-detection)
      labels: ["violence", "toxic"]               # labels
    )
    res = @copyleaks.text_moderation_client.submit_text(_authToken, scanId, submission)
    payload = JSON.parse(res.body)

    # Convert to OpenStruct
    textModerationResponse = Copyleaks::CopyleaksTextModerationResponseModel.new(**payload.transform_keys(&:to_sym))
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

CopyleaksDemo.run
sleep 