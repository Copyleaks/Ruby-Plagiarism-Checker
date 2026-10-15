require_relative '../../imageDetection/responses/CopyleaksAiImageDetectionScannedDocumentModel.rb'

module Copyleaks
  # Time ranges of one track (positions and lengths are in milliseconds).
  class CopyleaksAiVideoDetectionRangesModel
    attr_accessor :starts, :lengths

    def initialize(starts: nil, lengths: nil)
      @starts = starts
      @lengths = lengths
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(starts: json_hash['starts'], lengths: json_hash['lengths'])
    end

    def as_json(*_args)
      { 'starts' => @starts, 'lengths' => @lengths }.reject { |_k, v| v.nil? }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end

  # AI-detected segments of one track, plus the ranges that were not scored (exclude).
  class CopyleaksAiVideoDetectionTrackResultModel < CopyleaksAiVideoDetectionRangesModel
    attr_accessor :exclude

    def initialize(starts: nil, lengths: nil, exclude: nil)
      super(starts: starts, lengths: lengths)
      @exclude = exclude
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        starts: json_hash['starts'],
        lengths: json_hash['lengths'],
        exclude: CopyleaksAiVideoDetectionRangesModel.from_json(json_hash['exclude'])
      )
    end

    def as_json(*_args)
      super.merge('exclude' => @exclude&.as_json).reject { |_k, v| v.nil? }
    end
  end

  # Overall AI ratios (0.0 to 1.0), computed from the scored segments only.
  class CopyleaksAiVideoDetectionSummaryModel
    attr_accessor :audio_ai_ratio, :visual_ai_ratio, :overall_ai_ratio

    def initialize(audio_ai_ratio: nil, visual_ai_ratio: nil, overall_ai_ratio: nil)
      @audio_ai_ratio = audio_ai_ratio
      @visual_ai_ratio = visual_ai_ratio
      @overall_ai_ratio = overall_ai_ratio
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        audio_ai_ratio: json_hash['audioAIRatio'],
        visual_ai_ratio: json_hash['visualAIRatio'],
        overall_ai_ratio: json_hash['overallAIRatio']
      )
    end

    def as_json(*_args)
      {
        'audioAIRatio' => @audio_ai_ratio,
        'visualAIRatio' => @visual_ai_ratio,
        'overallAIRatio' => @overall_ai_ratio
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end

  # Information about the analyzed video.
  class CopyleaksAiVideoDetectionVideoInfoModel
    attr_accessor :duration, :metadata

    # @param duration [Float] In seconds.
    # @param metadata [CopyleaksImageMetadataModel] Optional provenance metadata.
    def initialize(duration: nil, metadata: nil)
      @duration = duration
      @metadata = metadata
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        duration: json_hash['duration'],
        metadata: CopyleaksImageMetadataModel.from_json(json_hash['metadata'])
      )
    end

    def as_json(*_args)
      {
        'duration' => @duration,
        'metadata' => @metadata ? JSON.parse(@metadata.to_json) : nil
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end

  # Metadata about the video scan. Same fields as the image model; unset fields are left out of the JSON.
  class CopyleaksAiVideoDetectionScannedVideoModel < CopyleaksAiImageDetectionScannedDocumentModel
    def as_json(*_args)
      super.reject { |_k, v| v.nil? }
    end
  end

  # AI video detection result delivered to your webhook; build it with from_json(JSON.parse(body)).
  # Check error first: when the scan failed, error (a Copyleaks::Error) is set and the result fields are nil.
  class CopyleaksAiVideoDetectionResponseModel
    attr_accessor :model, :audio_result, :visual_result, :summary, :is_ai_detected, :video_info, :scanned_video,
                  :error, :developer_payload

    def initialize(model: nil, audio_result: nil, visual_result: nil, summary: nil, is_ai_detected: nil,
                   video_info: nil, scanned_video: nil, error: nil, developer_payload: nil)
      @model = model
      @audio_result = audio_result
      @visual_result = visual_result
      @summary = summary
      @is_ai_detected = is_ai_detected
      @video_info = video_info
      @scanned_video = scanned_video
      @error = error
      @developer_payload = developer_payload
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        model: json_hash['model'],
        audio_result: CopyleaksAiVideoDetectionTrackResultModel.from_json(json_hash['audioResult']),
        visual_result: CopyleaksAiVideoDetectionTrackResultModel.from_json(json_hash['visualResult']),
        summary: CopyleaksAiVideoDetectionSummaryModel.from_json(json_hash['summary']),
        is_ai_detected: json_hash['isAiDetected'],
        video_info: CopyleaksAiVideoDetectionVideoInfoModel.from_json(json_hash['videoInfo']),
        scanned_video: CopyleaksAiVideoDetectionScannedVideoModel.from_json(json_hash['scannedVideo']),
        error: Error.from_json(json_hash['error']),
        developer_payload: json_hash['developerPayload']
      )
    end

    def as_json(*_args)
      {
        'model' => @model,
        'audioResult' => @audio_result&.as_json,
        'visualResult' => @visual_result&.as_json,
        'summary' => @summary&.as_json,
        'isAiDetected' => @is_ai_detected,
        'videoInfo' => @video_info&.as_json,
        'scannedVideo' => @scanned_video&.as_json,
        'error' => @error&.as_json,
        'developerPayload' => @developer_payload
      }.reject { |_k, v| v.nil? }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end
end
