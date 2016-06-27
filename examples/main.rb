require 'bundler/setup'
require 'copyleaks_api'

# firstly we need to create new Cloud entity
email = '<YOUR-EMAIL>'
api_key = '<YOUR-API-KEY>'
cloud = CopyleaksApi::CopyleaksCloud.new(email, api_key, :publisher)

# to check your balance just call balance

puts "Your balance is #{cloud.balance} credits"

# firstly we need to change work mode to sandbox

CopyleaksApi::Config.sandbox_mode = true

# now we can create new process by some url and custom callback
process = cloud.create_by_url('http://exmaple.com', http_callback: 'http://requestb.in/')

# Other scanning options
# Text scan:
#process = cloud.create_by_text("-Your text here-")

# Textual file scan:
#path = File.join(File.dirname(__FILE__), '..', 'spec', 'fixtures', 'files', 'lorem.txt')
#process = cloud.create_by_file(path)

# Ocr scan:
#path = File.join(File.dirname(__FILE__), '..', 'spec', 'fixtures', 'files', 'lorem.jpg')
#process = cloud.create_by_ocr(path, language: CopyleaksApi::Language.latin)

puts "Now process has state '#{process.status}'"

# to update process information we can just do this

# process.reload

# and it automatically call cloud.status with his id
# it need some time to process your request so we need to wait

while process.processing?
  sleep(1)
  process.reload
end

puts "And after sleep - #{process.status}"
# to get our results from processing we can just call correspond method

puts 'And its results are:'
puts process.result.inspect

# all results will be in array ow hashes with keys like Copyleaks API provides
# to get list of all existing processes we can call list method

processes = cloud.list
puts "Overall you have #{processes.size} processes"

# Delete finished process by PID:
#PID = '00000000-0000-0000-0000-000000000000'
#cloud.delete(PID)