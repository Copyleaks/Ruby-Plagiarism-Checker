require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_credit_balance(copyleaks, authToken)
    res = copyleaks.get_credits_balance(authToken)
    logInfo('get_credits_balance', res)
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
