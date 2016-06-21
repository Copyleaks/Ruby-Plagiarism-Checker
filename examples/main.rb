require 'bundler/setup'
require 'copyleaks_api'

# firstly we need to create new Cloud entity
email = 'your email'
api_key = 'your api key'
cloud = CopyleaksApi::CopyleaksCloud.new(email, api_key)

# firstly we need to change work mode to sandbox

CopyleaksApi::Config.sandbox_mode = true

# now we can create new process by some url

url_process = cloud.create_by_url('http://python.org')

# or from picture with text

path = File.join(File.dirname(__FILE__), '..', 'spec', 'fixtures', 'files', 'lorem.jpg')
ocr_process = cloud.create_by_ocr(path, language: CopyleaksApi::Language.latin)

puts "Now process has state '#{ocr_process.status}'"

# to update process information we can just do this

ocr_process.reload

# and it automatically call cloud.status with his id
# it need some time to process your request so we need to wait

while ocr_process.processing?
  sleep(1)
  ocr_process.reload
end

puts "And after sleep - #{ocr_process.status}"
# to get our results from processing we can just call correspond method

puts 'And its results are:'
puts ocr_process.result.inspect

# all results will be in array ow hashes with keys like Copyleaks API provides
# to get list of all existing processes we can call list method

processes = cloud.list
puts "Overall you have #{processes.size} processes"

# and delete any of them
first = processes.first
puts "Process #{first.process_id} is now #{first.delete}"

# also we can just specify needed id to delete

cloud.delete(processes[1].process_id)
