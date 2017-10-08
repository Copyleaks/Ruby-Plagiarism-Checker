module CopyleaksApi
  class ResultRecord
    def initialize(response)
      @URL = response['URL']
      @Percents = response['Percents']
      @NumberOfCopiedWords = response['NumberOfCopiedWords']
      @CachedVersion = response['CachedVersion']
      @Title = response['Title']
      @Introduction = response['Introduction']
      @ComparisonReport = response['ComparisonReport']
      @EmbededComparison = response['EmbededComparison']
    end
    
    def get_url
      @URL
    end
    
    def get_percents
      @Percents
    end
    
    def get_number_of_copied_words
      @NumberOfCopiedWords
    end
    
    def get_cached_version
      @CachedVersion
    end

    def get_title
      @Title
    end

    def get_introduction
      @Introduction
    end
    
    def get_comparison_report
      @ComparisonReport
    end
    
    def get_embeded_comparison
      @EmbededComparison
    end
    
    def to_s
      puts ""
      puts "Url: #{@URL}"
      puts "Percents: #{@Percents}%"
      puts "NumberOfCopiedWords: #{@NumberOfCopiedWords}"
      puts "CachedVersion: #{@CachedVersion}"
      puts "Title: #{@Title}"
      puts "Introduction: #{@Introduction}"
      puts "ComparisonReport: #{@ComparisonReport}"
      puts "EmbededComparison: #{@EmbededComparison}"
    end
  end
end