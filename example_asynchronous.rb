# Import the module
require_relative './lib/copyleaks_api'
# If you installed this library using gem install use this import
#require 'copyleaks_api'

# In order to use this API you need to register to Copyleaks at https://copyleaks.com/account/register
# Login using your account email and account key provided at api.copyleaks.com dashboards.
email = "<--YOUR-EMAIL-->"
api_key = "<--API-KEY-->"
# There are currently 3 available products - :businesses, :education, :websites
cloud = CopyleaksApi::CopyleaksCloud.new(email, api_key, :businesses)

# Check your account balance
puts "You have #{cloud.get_credits_balance} credits"

# Process Configuration
CopyleaksApi::Config.sandbox_mode = true  # Sandbox mode will not consume any credits while returning dummy results
CopyleaksApi::Config.http_callback = 'http://yoursite.here/callback/completion/'
# For testing purposes you can use http://requestb.in

#CopyleaksApi::Config
# For more information: https://api.copyleaks.com/GeneralDocumentation/RequestHeaders
# Available configuration options:
#CopyleaksApi::Config do |config|
#    config.sanbox_mode = true
#    config.allow_partial_scan = true
#    config.http_callback = 'http://yoursite.here/callback/completion/'
#    config.in_progress_result = 'http://yoursite.here/callback/results/'
#    config.email_callback = 'your@email.com'
#    config.custom_fields = { some_field: 'and its value' }
#    config.compare_only = true  # Only while using create-by-files
#    config.import_to_database_only = true  # To only upload your file to our database, will not consume any credits.
#end


# Create a process using one of the optional methods
# Available methods: create_by_url, create_by_text, create_by_file, create_by_files and create_by_ocr.
# For more information see our documentation on http://api.copyleaks.com/
begin
  process = cloud.create_by_url("https://microsoft.com/")
  #process = cloud.create_by_text("THE TEXT YOU WISH TO SCAN")
  #process = cloud.create_by_file(path_to_file)
  #processes = cloud.create_by_files(files_paths)
  #process = cloud.create_by_ocr(path_to_image, language: 'en') # Requires the language of the text.
                                                                # Use cloud.get_ocr_languages to get the supported langauges.
                                                                # or take a look at this page: https://api.copyleaks.com/GeneralDocumentation/OcrLanguagesList
  
  puts "Your scan(#{process.process_id}) was created successfully. We will trigger the callback soon."
rescue Exception => ex
  puts "Failed to create new process with exception: #{ex}"
end
