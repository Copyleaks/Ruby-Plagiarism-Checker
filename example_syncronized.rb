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
CopyleaksApi::Config.sandbox_mode = true  # Sandbox mode will not consume any credits while returning fake results
#CopyleaksApi::Config
# For more information: https://api.copyleaks.com/GeneralDocumentation/RequestHeaders
# Available configuration options:
#CopyleaksApi::Config do |config|
#    config.sanbox_mode = true
#    config.allow_partial_scan = true
#    config.http_callback = 'http://yoursite.here'
#    config.in_progress_result = 'http://yoursite.here'
#    config.email_callback = 'your@email.com'
#    config.custom_fields = { some_field: 'and its value' }
#    config.compare_only = true  # Only while using create-by-files
#end


# Create a process using one of the optional methods
# Available methods: create_by_url, create_by_text, create_by_file, create_by_files and create_by_ocr.
# For more information see our documentation on http://api.copyleaks.com/
process = cloud.create_by_url("https://copyleaks.com/")
#process = cloud.create_by_text("THE TEXT YOU WISH TO SCAN")
#process = cloud.create_by_file(path_to_file)
#processes = cloud.create_by_files(files_paths)
#process = cloud.create_by_ocr(path_to_image, language: 'en') # Requires the language of the text.
                                                              # Use cloud.get_ocr_languages to get the supported langauges.
                                                              # or take a look at this page: https://api.copyleaks.com/GeneralDocumentation/OcrLanguagesList
  
puts "Processing Started"

# Now we will check the status of the process until its done
# **We highly recommend to use the http_callback option at the config in order to get a callback once the process is finished**
# For more info visit: https://api.copyleaks.com/GeneralDocumentation/RequestHeaders
while process.processing?
    sleep(1)
    process.update_status
    puts "#"*(process.progress/2) + "-"*(50 - process.progress/2) + "#{process.progress}%"
end

puts "Processing Ended"
# to get our results from processing we can just call correspond method
results = process.get_results

puts "#{results.size} Results: "
results.each do |res|
  #puts cloud.get_comparison_report(res)
  #puts cloud.get_raw_text(res)
  puts res.to_s
end

# Delete the created process
#puts process.delete

# In order to get all your past processes
#processes = cloud.get_processes
#puts "Overall you have #{processes.size} processes"
#processes.each do |res|
#  puts res.to_s
#end
