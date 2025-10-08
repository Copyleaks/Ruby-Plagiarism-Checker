require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_usages_history(copyleaks, authToken)
    res = copyleaks.get_usages_history_csv(authToken, '01-01-2021', '02-02-2021')
    logInfo('get_usages_history_csv', res)
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
