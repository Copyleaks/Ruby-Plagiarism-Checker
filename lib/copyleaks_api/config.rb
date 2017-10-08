module CopyleaksApi
  class Config
    DEFAULTS = {
      sandbox_mode: false,
      allow_partial_scan: false,
      http_callback: nil,
      email_callback: nil,
      custom_fields: {},
      compare_only: false,
      in_progress_result: nil,
    }.freeze

    class << self
      attr_writer :sandbox_mode, :compare_only, :http_callback, :email_callback, :custom_fields, :allow_partial_scan, :in_progress_result

      DEFAULTS.each do |attr, value|
        # getters for all options
        define_method(attr) do
          var = instance_variable_get("@#{attr}")
          return var if var
          instance_variable_set("@#{attr}", value)
        end
      end

      # provide block syntax possibility for setting options
      def config
        yield(self)
      end

      # reset all options to default
      def reset
        DEFAULTS.each { |attr, value| instance_variable_set("@#{attr}", value) }
      end
    end
  end
end
