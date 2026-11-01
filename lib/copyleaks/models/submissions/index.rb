require_relative 'properties/index.rb'

require_relative 'submission_model.rb'
require_relative 'file_submission_model.rb'
require_relative 'file_ocr_submission_model.rb'
require_relative 'url_submission_model.rb'

require_relative 'ai_detection/ai_detection_submission_model.rb'
require_relative 'ai_detection/natural_language_submission_model.rb'
require_relative 'webhooks/index.rb'

require_relative 'writing_assistant/score_weights.rb'
require_relative 'writing_assistant/writing_assistant_submission_model.rb'

module Copyleaks
end
