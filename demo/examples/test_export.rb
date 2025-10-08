require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_export(copyleaks, authToken, webhook_url)
    scanId = '1611042641'
    
    export_result = Copyleaks::ExportResults.new(
      '2a1b402420',                                              # id
      "#{webhook_url}/export/#{scanId}/result/2a1b402420",      # endpoint
      'POST',                                                    # verb
      [%w[key1 value1], %w[key2 value2]]                        # headers
    )
    
    crawled_version = Copyleaks::ExportCrawledVersion.new(
      "#{webhook_url}/export/#{scanId}/crawled-version",        # endpoint
      'POST'                                                     # verb
    )
    
    model = Copyleaks::CopyleaksExportModel.new(
      "#{webhook_url}/export/#{scanId}",                        # completionWebhook
      [export_result],                                          # results
      crawled_version                                           # crawledVersion
    )

    copyleaks.export(authToken, scanId, scanId, model)
    logInfo('export')
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
