require_relative '../../lib/index'

module CopyleaksExamples
  def self.test_misc(copyleaks)
    ocr_supported_languages = copyleaks.get_ocr_supported_languages
    logInfo('get_ocr_supported_languages', ocr_supported_languages)

    supported_file_types = copyleaks.get_supported_file_types
    logInfo('get_supported_file_types', supported_file_types)

    release_notes = copyleaks.get_release_notes
    logInfo('get_release_notes', release_notes)
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
