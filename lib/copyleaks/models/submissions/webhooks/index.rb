module Copyleaks
  require_relative 'HelperModels/BaseModels/Metadata.rb'
  require_relative 'HelperModels/BaseModels/Webhook.rb'
  require_relative 'HelperModels/BaseModels/StatusWebhook.rb'

  require_relative 'HelperModels/ResultsModels/SharedResultsModel.rb'
  require_relative 'HelperModels/NewResultsModels/NewResultScore.rb'
  require_relative 'HelperModels/NewResultsModels/NewResultsInternet.rb'
  require_relative 'HelperModels/NewResultsModels/NewResultsRepositories.rb'

  require_relative 'HelperModels/ResultsModels/Batch.rb'
  require_relative 'HelperModels/ResultsModels/Internet.rb'
  require_relative 'HelperModels/ResultsModels/Database.rb'
  require_relative 'HelperModels/ResultsModels/Repositories.rb'
  require_relative 'HelperModels/ResultsModels/RepositoryMetadata.rb'
  require_relative 'HelperModels/ResultsModels/Score.rb'
  require_relative 'HelperModels/ResultsModels/Tags.rb'

  require_relative 'HelperModels/CompletedModels/Notifications.rb'
  require_relative 'HelperModels/CompletedModels/Results.rb'
  require_relative 'HelperModels/CompletedModels/ScannedDocument.rb'

  require_relative 'HelperModels/ErrorModels/Error.rb'
  require_relative 'HelperModels/NotificationsModels/Alerts.rb'
  require_relative 'HelperModels/ExportModels/Task.rb'

  require_relative 'CompletedWebhook.rb'
  require_relative 'CreditsCheckedWebhook.rb'
  require_relative 'ErrorWebhook.rb'
  require_relative 'IndexedWebhook.rb'
  require_relative 'ExportCompletedWebhook.rb'

  require_relative 'NewResultWebhook.rb'
end
