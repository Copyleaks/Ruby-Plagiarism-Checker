module Copyleaks
  class ExportCompletedWebhook < Webhook
    attr_reader :completed, :tasks

    def initialize(completed: nil, tasks: nil, **args)
      super(**args)
      @completed = completed
      @tasks = tasks
    end

    def as_json(*_args)
      super.merge(
        {
          completed: @completed,
          tasks: @tasks.respond_to?(:map) ? @tasks.map { |t| t.respond_to?(:as_json) ? t.as_json : t } : @tasks
        }
      )
    end

    def to_json(*options)
      as_json.to_json(*options)
    end
  end
end

