require 'webrick'
require 'json'

# If you use ngrok, expose local port 3001.
class ScanWebhookServlet < WEBrick::HTTPServlet::AbstractServlet

  def do_POST(req, res)
    path = req.path

    case path
    when %r{^/url-webhook/scan/(\w+)/completed$}
      scan_id = $1
      handle_completed(req, res, scan_id)
    when %r{^/url-webhook/scan/(\w+)/error$}
      scan_id = $1
      handle_error(req, res, scan_id)
    when %r{^/url-webhook/scan/(\w+)/creditschecked$}
      scan_id = $1
      handle_credits_checked(req, res, scan_id)
    when %r{^/url-webhook/scan/(\w+)/indexed$}
      scan_id = $1
      handle_indexed(req, res, scan_id)
    when %r{^/url-webhook/new-result$}
      scan_id = $1
      handle_new_result(req, res, scan_id)
    else
      res.status = 404
      res.body = "Endpoint not found"
    end
  rescue JSON::ParserError
    res.status = 400
    res.body = "Invalid JSON payload"
  rescue StandardError => e
    res.status = 500
    res.body = "Internal Server Error: #{e.message}"
    @logger.error("Error in webhook handler: #{e.message}\n#{e.backtrace.join("\n")}") if @logger
  end

  private

  def handle_completed(req, res, scan_id)
    payload = JSON.parse(req.body)
    payload_hash = JSON.parse(req.body).transform_keys(&:to_sym)

    completed = Copyleaks::CompletedWebhook.new(**payload.transform_keys(&:to_sym))

    puts "[COMPLETED] scan_id: #{scan_id}"
    pp completed.scannedDocument 

    # Read the AI text detection result from the 'suspected-ai-text' alert, if the scan produced one
    begin
      ai_result = completed.ai_detection_result
      if ai_result.nil?
        puts "[COMPLETED] no AI text detection result in this webhook"
      elsif ai_result.summary
        puts "[COMPLETED] AI text detection: ai=#{ai_result.summary.ai}, human=#{ai_result.summary.human}, model=#{ai_result.model_version}"
      end
    rescue JSON::ParserError => e
      puts "[COMPLETED] could not parse the AI alert additionalData: #{e.message}"
    end

    # Acknowledge the webhook even when the AI alert could not be decoded
    res.status = 200
    res.body = "completed received #{completed.to_json()}"
  end

  def handle_error(req, res, scan_id)
    payload = JSON.parse(req.body)
    error = Copyleaks::ErrorWebhook.new(**payload.transform_keys(&:to_sym))
    puts "[ERROR WEBHOOK] scan_id: #{scan_id}"
    pp error.error
    res.status = 200
    res.body = "Error received #{error.to_json()}"
  end

   def handle_credits_checked(req, res, scan_id)
    payload = JSON.parse(req.body)
    payload_hash = JSON.parse(req.body).transform_keys(&:to_sym)

    credits_checked = Copyleaks::CreditsCheckedWebhook.new(**payload.transform_keys(&:to_sym))

    puts "[CREDITS CHECKED] scan_id: #{scan_id}"
    pp credits_checked.scannedDocument 

    res.status = 200
    res.body = "CREDITS CHECKED received #{credits_checked.to_json()}"
  end

  def handle_indexed(req, res, scan_id)
    payload = JSON.parse(req.body)
    payload_hash = JSON.parse(req.body).transform_keys(&:to_sym)

    indexed = Copyleaks::IndexedWebhook.new(**payload.transform_keys(&:to_sym))

    puts "[INDEXED] scan_id: #{scan_id}"
    pp indexed.developerPayload 

    res.status = 200
    res.body = "INDEXED received #{indexed.to_json()}"
  end

  def handle_new_result(req, res, scan_id)
    payload = JSON.parse(req.body)
    payload_hash = JSON.parse(req.body).transform_keys(&:to_sym)

    new_result = Copyleaks::NewResultWebhook.new(**payload.transform_keys(&:to_sym))

    puts "[New Result Webhook] scan_id: #{scan_id}"
    json_string= new_result.to_json() 

    res.status = 200
    res.body = "New Result Webhook received #{json_string}"
  end
end

class WebhookServer
  @@server = nil
  @@server_thread = nil

  def self.start(port = 3001)
    log = WEBrick::Log.new($stderr, WEBrick::Log::DEBUG)
    @@server = WEBrick::HTTPServer.new(Port: port, Logger: log)

    # do_POST routes the sub-paths.
    @@server.mount '/url-webhook/scan', ScanWebhookServlet

    @@server_thread = Thread.new { @@server.start }
    puts "WEBrick server started on port #{port}"
    puts "Press Ctrl+C to stop the server..."
  end

  def self.shutdown
    if @@server
      puts "\nShutting down webhook server..."
      @@server.shutdown
      @@server_thread.join if @@server_thread
      puts "Server stopped."
    end
  end
end
