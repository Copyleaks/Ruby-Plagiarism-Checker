module Copyleaks
  class Utils
    def self.is_success_status_code(code)
      code.to_i >= 200 && code.to_i <= 299
    end

    def self.is_under_maintenance_response(code)
      code.to_i == 503
    end

    def self.is_rate_limit_response(code)
      code.to_i == 429
    end
  end
end
