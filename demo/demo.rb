require_relative '../lib/index'
require 'json'
require 'date'
require 'base64'
require_relative 'base64logo.rb'
require_relative './webhookServer'

require_relative './examples/test_misc.rb'
require_relative './examples/test_credit_balance.rb'
require_relative './examples/test_usages_history.rb'
require_relative './examples/test_delete.rb'
require_relative './examples/test_resend_webhook.rb'
require_relative './examples/test_export.rb'
require_relative './examples/test_start.rb'
require_relative './examples/test_submit_url.rb'
require_relative './examples/test_submit_file.rb'
require_relative './examples/test_submit_ocr_file.rb'
require_relative './examples/test_ai_detection_natural_language.rb'
require_relative './examples/test_writing_assistant.rb'
require_relative './examples/test_text_moderation.rb'
require_relative './examples/test_image_detection.rb'

module CopyleaksDemo
  USER_EMAIL = '<YOUR EMAIL>'
  USER_API_KEY = '<YOUR KEY>'
  WEBHOOK_URL = '<WEBHOOK URL>'

  def self.run
    @copyleaks = Copyleaks::API.new    
    loginResponse = @copyleaks.login(USER_EMAIL, USER_API_KEY)
    logInfo('login', loginResponse)

    @copyleaks.verify_auth_token(loginResponse)

    # Call any other example loaded above the same way, e.g. CopyleaksExamples.test_submit_url.
    CopyleaksExamples.test_image_detection(@copyleaks, loginResponse)
  rescue StandardError => e
    puts '--------ERROR-------'
    puts
    puts e.message
    puts
    puts '--------------------'
  end

  def self.logInfo(title, info = nil)
    puts '-------------' + title + '-------------'
    puts info.to_json unless info.nil?
    puts
  rescue StandardError => e
    puts info.inspect unless info.nil?
    puts
  end
end

# Start the webhook server in a background thread
puts "Starting webhook server..."
WebhookServer.start

trap('INT') do
  puts "\n\nReceived interrupt signal (Ctrl+C)..."
  WebhookServer.shutdown
  exit(0)
end

CopyleaksDemo.run

# Keep running so the webhook server can receive requests.
puts "\nDemo completed. Webhook server is still running..."
puts "Press Ctrl+C to stop the server and exit."
sleep 