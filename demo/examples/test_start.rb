require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_start(copyleaks, authToken)
    data = Copyleaks::CopyleaksStartRequestModel.new(
      ['1611225876017'],                                        # scans
      Copyleaks::CopyleaksStartErrorHandlings::IGNORE           # errorHandling
    )
    
    copyleaks.start(authToken, data)
    logInfo('start')
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
