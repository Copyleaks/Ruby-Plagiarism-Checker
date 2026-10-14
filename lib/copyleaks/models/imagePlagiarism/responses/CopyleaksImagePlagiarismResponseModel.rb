#
#  The MIT License(MIT)
#
#  Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
# =

module Copyleaks
  # Metadata about the submitted image and the scan.
  class CopyleaksImagePlagiarismScannedImageModel
    attr_accessor :scan_id, :expected_credits, :actual_credits, :creation_time, :width, :height, :filename

    def initialize(scan_id: nil, expected_credits: nil, actual_credits: nil, creation_time: nil, width: nil,
                   height: nil, filename: nil)
      @scan_id = scan_id
      @expected_credits = expected_credits
      @actual_credits = actual_credits
      @creation_time = creation_time
      @width = width
      @height = height
      @filename = filename
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        scan_id: json_hash['scanId'],
        expected_credits: json_hash['expectedCredits'],
        actual_credits: json_hash['actualCredits'],
        creation_time: json_hash['creationTime'],
        width: json_hash['width'],
        height: json_hash['height'],
        filename: json_hash['filename']
      )
    end

    def as_json(*_args)
      {
        'scanId' => @scan_id,
        'expectedCredits' => @expected_credits,
        'actualCredits' => @actual_credits,
        'creationTime' => @creation_time,
        'width' => @width,
        'height' => @height,
        'filename' => @filename
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end

  # One image found on the web.
  class CopyleaksImagePlagiarismInternetMatchModel
    # matchType values
    FULL = 0
    PARTIAL = 1

    # @return [String] The URL of the matching image.
    attr_accessor :url
    # @return [Integer] 0 (full: exact or near-exact copy) or 1 (partial: cropped, resized or modified).
    attr_accessor :match_type
    # @return [Array<String>, nil] URLs of the web pages where the image was found. nil when none were found.
    attr_accessor :web_pages

    def initialize(url: nil, match_type: nil, web_pages: nil)
      @url = url
      @match_type = match_type
      @web_pages = web_pages
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      pages = json_hash['webPages']
      new(
        url: json_hash['url'],
        match_type: json_hash['matchType'],
        web_pages: pages.is_a?(Array) ? pages.map { |page| page.is_a?(Hash) ? page['url'] : page } : nil
      )
    end

    def as_json(*_args)
      {
        'url' => @url,
        'matchType' => @match_type,
        'webPages' => @web_pages&.map { |page_url| { 'url' => page_url } }
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end

  # Match counts.
  class CopyleaksImagePlagiarismScoreModel
    attr_accessor :total_matches, :full_matches, :partial_matches

    def initialize(total_matches: nil, full_matches: nil, partial_matches: nil)
      @total_matches = total_matches
      @full_matches = full_matches
      @partial_matches = partial_matches
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        total_matches: json_hash['totalMatches'],
        full_matches: json_hash['fullMatches'],
        partial_matches: json_hash['partialMatches']
      )
    end

    def as_json(*_args)
      {
        'totalMatches' => @total_matches,
        'fullMatches' => @full_matches,
        'partialMatches' => @partial_matches
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end

  # The detection results.
  class CopyleaksImagePlagiarismMatchesModel
    attr_accessor :internet, :score

    def initialize(internet: nil, score: nil)
      @internet = internet
      @score = score
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      internet = json_hash['internet']
      new(
        internet: internet.is_a?(Array) ? internet.map { |m| CopyleaksImagePlagiarismInternetMatchModel.from_json(m) } : nil,
        score: CopyleaksImagePlagiarismScoreModel.from_json(json_hash['score'])
      )
    end

    def as_json(*_args)
      {
        'internet' => @internet&.map(&:as_json),
        'score' => @score&.as_json
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end

  # The Image Plagiarism Detector response.
  # Build it from the client result: CopyleaksImagePlagiarismResponseModel.from_json(result)
  class CopyleaksImagePlagiarismResponseModel
    attr_accessor :developer_payload, :scanned_image, :matches

    def initialize(developer_payload: nil, scanned_image: nil, matches: nil)
      @developer_payload = developer_payload
      @scanned_image = scanned_image
      @matches = matches
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        developer_payload: json_hash['developerPayload'],
        scanned_image: CopyleaksImagePlagiarismScannedImageModel.from_json(json_hash['scannedImage']),
        matches: CopyleaksImagePlagiarismMatchesModel.from_json(json_hash['matches'])
      )
    end

    def as_json(*_args)
      {
        'developerPayload' => @developer_payload,
        'scannedImage' => @scanned_image&.as_json,
        'matches' => @matches&.as_json
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end
end
