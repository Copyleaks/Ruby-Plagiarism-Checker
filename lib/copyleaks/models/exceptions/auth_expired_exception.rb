module Copyleaks
  class AuthExpiredException < RuntimeError
    def initialize
      super 'Authentication Expired. Need to login again'
    end
  end
end
