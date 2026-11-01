module Copyleaks
  class NewResultWebhook < Webhook
    attr_reader :score, :internet, :database, :batch, :repositories, :internalAIData

    # @param [Array] internalAIData Internal AI Source Match results.
    def initialize(score: nil, internet: nil, database: nil, batch: nil, repositories: nil, internalAIData: nil, **args)
      super(**args)
      @score = score
      @internet = internet
      @database = database
      @batch = batch
      @repositories = repositories
      @internalAIData = internalAIData
    end

    def as_json(*_args)
      hash = {
        score: @score,
        internet: @internet,
        database: @database,
        batch: @batch,
        repositories: @repositories
      }
      hash[:internalAIData] = @internalAIData unless @internalAIData.nil?
      hash.merge(super)
    end

    def to_json(*options)
      as_json.to_json(*options)
    end
  end
end
