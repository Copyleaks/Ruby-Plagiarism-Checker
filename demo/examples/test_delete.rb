require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_delete(copyleaks, authToken, webhook_url)
    id_object = Copyleaks::IdObject.new(
      'e39awrk3829v3x3x'                                        # id
    )
    
    model = Copyleaks::CopyleaksDeleteRequestModel.new(
      [id_object],                                              # scans
      true,                                                     # purge
      "#{webhook_url}/delete"                                   # completionWebhook
    )
    
    copyleaks.delete(authToken, model)
    logInfo('delete')
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
