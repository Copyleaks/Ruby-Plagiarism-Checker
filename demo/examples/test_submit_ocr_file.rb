require_relative '../../lib/index'
require_relative '../base64logo.rb'

module CopyleaksExamples
  def self.test_submit_ocr_file(copyleaks, authToken, webhook_url)
    scanId = DateTime.now.strftime('%Q').to_s
    submisson = Copyleaks::CopyleaksFileOcrSubmissionModel.new(
      'en',
      'aGVsbG8gd29ybGQ=',
      'ruby.txt',
      Copyleaks::SubmissionProperties.new(
        Copyleaks::SubmissionWebhooks.new("#{webhook_url}/url-webhook/scan/#{scanId}/{STATUS}"),
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

    copyleaks.submit_file_ocr(authToken, scanId, submisson)
    logInfo('submit_file_ocr')
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
