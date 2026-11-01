module Copyleaks
  class Notifications
    attr_reader :alerts

    # @param [Array<Alerts>] alerts
    def initialize(alerts: nil)
      if !alerts.nil? && !(alerts.is_a?(Array) && alerts.all? { |a| a.is_a?(Alerts) })
        raise 'Copyleaks::Notifications - alerts must be an array of Alerts objects'
      end

      @alerts = alerts
    end

    def as_json(*_args)
      {
        alerts: @alerts
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end