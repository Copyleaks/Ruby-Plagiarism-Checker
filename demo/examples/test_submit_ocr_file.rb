require_relative '../../lib/index'
require_relative '../base64logo.rb'

module CopyleaksExamples
  def self.test_submit_ocr_file(copyleaks, authToken, webhook_url)
    scanId = DateTime.now.strftime('%Q').to_s
    
    webhooks = Copyleaks::SubmissionWebhooks.new(
      "#{webhook_url}/url-webhook/scan/#{scanId}/{STATUS}"      # completed
    )
    author = Copyleaks::SubmissionAuthor.new(
      'Author_name'                                             # name
    )
    filter = Copyleaks::SubmissionFilter.new(
      true,                                                     # includeSimilar
      true,                                                     # includeIdentical
      true                                                      # includeMinorChanges
    )
    
    copyleaks_db = Copyleaks::SubmissionScanningCopyleaksDB.new(
      true,                                                     # includeMySubmissions
      true                                                      # includeOthersSubmissions
    )
    scanning = Copyleaks::SubmissionScanning.new(
      true,                                                     # internet
      nil,                                                      # internalDatabase
      nil,                                                      # externalDatabase
      copyleaks_db                                              # copyleaksDB
    )
    
    repository = Copyleaks::SubmissionRepository.new(
      'repo-1'                                                  # id
    )
    indexing = Copyleaks::SubmissionIndexing.new(
      [repository]                                              # repositories
    )
    
    exclude = Copyleaks::SubmissionExclude.new(
      true,                                                     # quotes
      true,                                                     # references
      true,                                                     # titles
      true,                                                     # tableTitles
      true                                                      # codeTitles
    )
    pdf = Copyleaks::SubmissionPDF.new(
      true,                                                     # create
      'pdf-title',                                              # title
      BASE64_LOGO,                                              # logoImage
      false                                                     # rtl
    )
    sensitive_data = Copyleaks::SubmissionSensitiveData.new(
      false                                                     # scanWithoutIndexing
    )
    
    properties = Copyleaks::SubmissionProperties.new(
      webhooks,                                                 # webhooks
      true,                                                     # includeHtml
      'developer_payloads_test',                                # customFields
      true,                                                     # sandbox
      60,                                                       # expiration
      1,                                                        # sensitivityLevel
      true,                                                     # cheatDetection
      Copyleaks::SubmissionActions::SCAN,                       # action
      author,                                                   # author
      filter,                                                   # filters
      scanning,                                                 # scanning
      indexing,                                                 # indexing
      exclude,                                                  # exclude
      pdf,                                                      # pdf
      sensitive_data                                            # sensitiveDataProtection
    )
    
    submisson = Copyleaks::CopyleaksFileOcrSubmissionModel.new(
      'en',                                                     # language
      'aGVsbG8gd29ybGQ=',                                       # base64
      'ruby.txt',                                               # filename
      properties                                                # properties
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
