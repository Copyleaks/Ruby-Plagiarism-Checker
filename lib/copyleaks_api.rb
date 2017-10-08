unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
end
require 'copyleaks_api/version'

require 'copyleaks_api/errors'

require 'copyleaks_api/Models/ResultRecord'

require 'copyleaks_api/validators/custom_fields_validator'
require 'copyleaks_api/validators/email_validator'
require 'copyleaks_api/validators/file_validator'
require 'copyleaks_api/validators/response_validator'
require 'copyleaks_api/validators/url_validator'
require 'copyleaks_api/validators/language_validator'

require 'copyleaks_api/copyleaks_cloud'
require 'copyleaks_api/access_token'
require 'copyleaks_api/api'
require 'copyleaks_api/config'
require 'copyleaks_api/copyleaks_process'

module CopyleaksApi
end
