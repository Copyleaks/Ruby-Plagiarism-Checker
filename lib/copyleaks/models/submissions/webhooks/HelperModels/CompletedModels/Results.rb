module Copyleaks
  class Results
    attr_reader :database, :batch, :repositories, :score, :internet, :internalAIData

    # @param [Array<Database>] database
    # @param [Array<Batch>] batch
    # @param [Array<Repositories>] repositories
    # @param [Score] score
    # @param [Array<Internet>] internet
    # @param [Array<Hash>] internalAIData Internal AI Source Match results.
    def initialize(database: nil, batch: nil, repositories: nil, score: nil, internet: nil, internalAIData: nil)
      if !internalAIData.nil? && !internalAIData.is_a?(Array)
        raise 'Copyleaks::Results - internalAIData must be an array'
      end
      if !database.nil? && !(database.is_a?(Array) && database.all? { |d| d.is_a?(Database) })
        raise 'Copyleaks::Results - database must be an array of Database objects'
      end
      if !batch.nil? && !(batch.is_a?(Array) && batch.all? { |b| b.is_a?(Batch) })
        raise 'Copyleaks::Results - batch must be an array of Batch objects'
      end
      if !repositories.nil? && !(repositories.is_a?(Array) && repositories.all? { |r| r.is_a?(Repositories) })
        raise 'Copyleaks::Results - repositories must be an array of Repositories objects'
      end
      if !score.nil? && !score.is_a?(Score)
        raise 'Copyleaks::Results - score must be a Score object'
      end
      if !internet.nil? && !(internet.is_a?(Array) && internet.all? { |i| i.is_a?(Internet) })
        raise 'Copyleaks::Results - internet must be an array of Internet objects'
      end

      @database = database
      @batch = batch
      @repositories = repositories
      @score = score
      @internet = internet
      @internalAIData = internalAIData
    end

    def as_json(*_args)
      {
        database: @database,
        batch: @batch,
        repositories: @repositories,
        score: @score,
        internet: @internet,
        internalAIData: @internalAIData
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end