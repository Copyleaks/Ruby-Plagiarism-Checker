require '../lib/index'
require 'json'
require 'date'
module CopyleaksDemo
  USER_EMAIL = '<YOUR EMAIL>'
  USER_API_KEY = '<YOUR KEY>'
  WEBHOOK_URL = '<WEBHOOK URL>'

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

    # test_submit_file(loginResponse)

    # test_submit_ocr_file(loginResponse)
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
        Copyleaks::SubmissionActions::CHECKCREDITS,
        Copyleaks::SubmissionAuthor.new('Bayan'),
        Copyleaks::SubmissionFilter.new(true, true, true),
        Copyleaks::SubmissionScanning.new(true, nil, nil, Copyleaks::SubmissionScanningCopyleaksDB.new(true, true)),
        Copyleaks::SubmissionIndexing.new([Copyleaks::SubmissionRepository.new('repo-1')]),
        Copyleaks::SubmissionExclude.new(true, true, true, true, true),
        Copyleaks::SubmissionPDF.new(true, 'pdf-title', 'https://lti.copyleaks.com/images/copyleaks50x50.png', false),
        Copyleaks::SubmissionSensitiveData.new(true)
      )
    )

    @copyleaks.submit_file_ocr('education', _authToken, scanId, submisson)
    logInfo('submit_file_ocr')
  end

  def self.test_submit_file(_authToken)
    scanId = DateTime.now.strftime('%Q').to_s
    submisson = Copyleaks::CopyleaksFileSubmissionModel.new(
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
        Copyleaks::SubmissionActions::CHECKCREDITS,
        Copyleaks::SubmissionAuthor.new('Bayan'),
        Copyleaks::SubmissionFilter.new(true, true, true),
        Copyleaks::SubmissionScanning.new(true, nil, nil, Copyleaks::SubmissionScanningCopyleaksDB.new(true, true)),
        Copyleaks::SubmissionIndexing.new([Copyleaks::SubmissionRepository.new('repo-1')]),
        Copyleaks::SubmissionExclude.new(true, true, true, true, true),
        Copyleaks::SubmissionPDF.new(true, 'pdf-title', 'https://lti.copyleaks.com/images/copyleaks50x50.png', false),
        Copyleaks::SubmissionSensitiveData.new(true)
      )
    )

    @copyleaks.submit_file('education', _authToken, scanId, submisson)
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
        Copyleaks::SubmissionActions::CHECKCREDITS,
        Copyleaks::SubmissionAuthor.new('Bayan'),
        Copyleaks::SubmissionFilter.new(true, true, true),
        Copyleaks::SubmissionScanning.new(true, nil, nil, Copyleaks::SubmissionScanningCopyleaksDB.new(true, true)),
        Copyleaks::SubmissionIndexing.new([Copyleaks::SubmissionRepository.new('repo-1')]),
        Copyleaks::SubmissionExclude.new(true, true, true, true, true),
        Copyleaks::SubmissionPDF.new(true, 'pdf-title', 'https://lti.copyleaks.com/images/copyleaks50x50.png', false),
        Copyleaks::SubmissionSensitiveData.new(true)
      )
    )

    @copyleaks.submit_url('education', _authToken, scanId, submisson)
    logInfo('submit_url')
  end

  def self.test_start(_authToken)
    data = Copyleaks::CopyleaksStartRequestModel.new(['1611225876017'],
                                                     Copyleaks::CopyleaksStartErrorHandlings::IGNORE)
    @copyleaks.start('education', _authToken, data)
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
    @copyleaks.resend_webhook('education', authToken, 'gzs55hrpefsaplcp')
    logInfo('resend_webhook:education')
  end

  def self.test_delete(authToken)
    model = Copyleaks::CopyleaksDeleteRequestModel.new(
      [
        Copyleaks::IdObject.new('e39awrk3829v3x3x')
      ],
      true,
      "#{WEBHOOK_URL}/delete"
    )
    @copyleaks.delete('education', authToken, model)
    logInfo('delete:education')
  end

  def self.test_usages_history(authToken)
    res = @copyleaks.get_usages_history_csv('education', authToken, '01-01-2021', '02-02-2021')
    logInfo('get_usages_history_csv:education', res)
  end

  def self.test_credit_balance(authToken)
    education_res = @copyleaks.get_credits_balance('education', authToken)
    logInfo('get_credits_balance:education', education_res)
    businesses_res = @copyleaks.get_credits_balance('businesses', authToken)
    logInfo('get_credits_balance:businesses', businesses_res)
  end

  def self.test_misc
    ocr_supported_languages = @copyleaks.get_ocr_supported_languages
    logInfo('get_ocr_supported_languages', ocr_supported_languages)

    supported_file_types = @copyleaks.get_supported_file_types
    logInfo('get_supported_file_types', supported_file_types)

    release_notes = @copyleaks.get_release_notes
    logInfo('get_release_notes', release_notes)
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
