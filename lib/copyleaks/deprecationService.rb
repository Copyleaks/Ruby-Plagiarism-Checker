module Copyleaks
  class DeprecationService  # Changed: deprecationService → DeprecationService
    def self.show_deprecation_message
      # Ruby equivalent of Trace.WriteLine - using logger or puts with warning
      warn "DEPRECATION NOTICE: AI Code Detection will be discontinued on August 29, 2025. Please remove AI code detection integrations before the sunset date."
      # Red colored console output using ANSI escape codes
      print "\033[31m"  # Red color
      puts "════════════════════════════════════════════════════════════════════"
      puts "DEPRECATION NOTICE !!!"
      puts "AI Code Detection will be discontinued on August 29, 2025."
      puts "Please remove AI code detection integrations before the sunset date."
      puts "════════════════════════════════════════════════════════════════════"
      print "\033[0m"   # Reset color
    end
  end
end