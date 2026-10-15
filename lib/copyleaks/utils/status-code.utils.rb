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

    # True for nil or an Array of [name, value] String pairs, e.g. [['Authorization', 'Bearer my-token']].
    def self.headers_valid?(headers)
      return true if headers.nil?
      return false unless headers.is_a?(Array)

      headers.all? { |pair| pair.is_a?(Array) && pair.length == 2 && pair.all? { |part| part.is_a?(String) } }
    end
  end
end
