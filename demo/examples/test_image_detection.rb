require_relative '../../lib/index'
require 'base64'

module CopyleaksExamples
  def self.test_image_detection(copyleaks, authToken)
    puts "Submitting a new image for AI image detection..."
    
    scanId = DateTime.now.strftime('%Q').to_s
    
    # Read and encode your image file to base64
    image_path = "Path/to/your/image.jpg" # Update this path to your image
    base64_image = Base64.strict_encode64(File.read(image_path))
    
    model = Copyleaks::CopyleaksAiImageDetectionRequestModel.new(
      base64_image,
      "image2.png",
      Copyleaks::CopyleaksAiImageDetectionModels::AI_IMAGE_1_ULTRA, 
      true # sandbox mode
    )
    
    res = copyleaks.ai_image_detection_client.submit_(authToken, scanId, model)
    logInfo('AI Image Detection - submit_image', res)
  rescue StandardError => e
    puts "Error in test_image_detection: #{e.message}"
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
