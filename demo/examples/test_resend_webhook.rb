require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_resend_webhook(copyleaks, authToken)
    copyleaks.resend_webhook(authToken, 'gzs55hrpefsaplcp')
    logInfo('resend_webhook')
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
