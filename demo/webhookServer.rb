require 'webrick'
require 'json'

## if you are using ngrok then expose your local host to port 3001
class ScanWebhookServlet < WEBrick::HTTPServlet::AbstractServlet

  # This method handles POST requests to paths mounted to this servlet
  def do_POST(req, res)
    # Extract the full path from the request
    path = req.path

    # Use regex to match the path and extract parameters
    case path
    when %r{^/url-webhook/scan/(\w+)/completed$}
      scan_id = $1 # $1 refers to the first captured group in the last successful regex match
      handle_completed(req, res, scan_id)
    when %r{^/url-webhook/scan/(\w+)/error$}
      scan_id = $1
      handle_error(req, res, scan_id)
    when %r{^/url-webhook/scan/(\w+)/creditsChecked$}
      scan_id = $1
      handle_credits_checked(req, res, scan_id)
    when %r{^/url-webhook/scan/(\w+)/indexed$}
      scan_id = $1
      handle_indexed(req, res, scan_id)
    when %r{^/url-webhook/new-result$}
      scan_id = $1
      handle_new_result(req, res, scan_id)
    else
      # If no specific webhook path matches, return 404 Not Found
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

  # Helper method for handling completed webhooks
  def handle_completed(req, res, scan_id)
    payload = JSON.parse(req.body)
    # Parse and symbolize keys
    payload_hash = JSON.parse(req.body).transform_keys(&:to_sym)

    # Convert to OpenStruct
    completed = Copyleaks::CompletedWebhook.new(**payload.transform_keys(&:to_sym))

    puts "[COMPLETED] scan_id: #{scan_id}"
    pp completed.scannedDocument 

    res.status = 200
    res.body = "completed received #{completed.to_json()}"
  end

  # Helper method for handling ERROR webhooks
  def handle_error(req, res, scan_id)
    payload = JSON.parse(req.body)
    error = Copyleaks::ErrorWebhook.new(**payload.transform_keys(&:to_sym))
    puts "[ERROR WEBHOOK] scan_id: #{scan_id}"
    pp error.error
    res.status = 200
    res.body = "Error received #{error.to_json()}"
  end

  # Helper method for handling CREDITS CHECKED webhooks
   def handle_credits_checked(req, res, scan_id)
    payload = JSON.parse(req.body)
    # Parse and symbolize keys
    payload_hash = JSON.parse(req.body).transform_keys(&:to_sym)

    # Convert to OpenStruct
    credits_checked = Copyleaks::CreditsCheckedWebhook.new(**payload.transform_keys(&:to_sym))

    puts "[CREDITS CHECKED] scan_id: #{scan_id}"
    pp credits_checked.scannedDocument 

    res.status = 200
    res.body = "CREDITS CHECKED received #{credits_checked.to_json()}"
  end

  # Helper method for handling INDEXED webhooks
  def handle_indexed(req, res, scan_id)
    payload = JSON.parse(req.body)
    # Parse and symbolize keys
    payload_hash = JSON.parse(req.body).transform_keys(&:to_sym)

    # Convert to OpenStruct
    indexed = Copyleaks::IndexedWebhook.new(**payload.transform_keys(&:to_sym))

    puts "[INDEXED] scan_id: #{scan_id}"
    pp indexed.developerPayload 

    res.status = 200
    res.body = "INDEXED received #{indexed.to_json()}"
  end

  # Helper method for handling NEW-RESULT webhooks
  def handle_new_result(req, res, scan_id)
    payload = JSON.parse(req.body)
    # Parse and symbolize keys
    payload_hash = JSON.parse(req.body).transform_keys(&:to_sym)

    # Convert to OpenStruct
    new_result = Copyleaks::NewResultWebhook.new(**payload.transform_keys(&:to_sym))

    puts "[New Result Webhook] scan_id: #{scan_id}"
    json_string= new_result.to_json() 

    res.status = 200
    res.body = "New Result Webhook received #{json_string}"
  end
end

class WebhookServer
  def self.start(port = 3001)
    log = WEBrick::Log.new($stderr, WEBrick::Log::DEBUG)
    server = WEBrick::HTTPServer.new(Port: port, Logger: log)

    # Mount the servlet to a base path.
    # The servlet's do_POST method will handle the sub-paths.
    server.mount '/url-webhook/scan', ScanWebhookServlet

    trap('INT') { server.shutdown }
    Thread.new { server.start }
    puts "WEBrick server started on port #{port}"
  end
end
