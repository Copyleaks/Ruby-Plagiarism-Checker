require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_export(copyleaks, authToken, webhook_url)
    scanId = '1611042641'
    model = Copyleaks::CopyleaksExportModel.new(
      "#{webhook_url}/export/#{scanId}",
      [
        Copyleaks::ExportResults.new('2a1b402420', "#{webhook_url}/export/#{scanId}/result/2a1b402420", 'POST',
                                     [%w[key1 value1], %w[key2 value2]])
      ],
      Copyleaks::ExportCrawledVersion.new("#{webhook_url}/export/#{scanId}/crawled-version", 'POST')
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
