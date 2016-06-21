module CopyleaksApi
  class Config
    DEFAULTS = {
      sandbox_mode: false,
      allow_partial_scan: false,
      http_callback: nil,
      email_callback: nil,
      custom_fields: {},
    }.freeze

    class << self
      attr_writer :sandbox_mode, :http_callback, :email_callback, :custom_fields, :allow_partial_scan

      DEFAULTS.each do |attr, value|
        define_method(attr) do
          var = instance_variable_get("@#{attr}")
          return var if var
          instance_variable_set("@#{attr}", value)
        end
      end

      def config
        yield(self)
      end

      def reset
        DEFAULTS.each do |attr, value|
          instance_variable_set("@#{attr}", value)
        end
      end
    end
  end
end
