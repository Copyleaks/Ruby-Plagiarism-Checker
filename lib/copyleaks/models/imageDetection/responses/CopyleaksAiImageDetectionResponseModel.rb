# frozen_string_literal: true

module Copyleaks
  # AI image detection result.
  class CopyleaksAiImageDetectionResponseModel
    attr_accessor :model

    attr_accessor :result

    attr_accessor :summary

    attr_accessor :image_info

    attr_accessor :scanned_document

    attr_accessor :is_ai_detected

    # Present only when the request set object_detection. Look entries up by object, not by position.
    attr_accessor :detected_objects

    # Set only in the webhook of a failed asynchronous scan; the result fields are then nil. Check it first.
    attr_accessor :error

    # Echoed from the asynchronous submit request.
    attr_accessor :developer_payload

    def initialize(model: nil, result: nil, summary: nil, image_info: nil, scanned_document: nil,
                   is_ai_detected: nil, detected_objects: nil, error: nil, developer_payload: nil)
      @model = model
      @result = result
      @summary = summary
      @image_info = image_info
      @scanned_document = scanned_document
      @is_ai_detected = is_ai_detected
      @detected_objects = detected_objects
      @error = error
      @developer_payload = developer_payload
    end

    def self.from_json(json_hash)
      return nil if json_hash.nil?

      result = CopyleaksAiImageDetectionResultModel.from_json(json_hash['result']) if json_hash['result']
      summary = CopyleaksAiImageDetectionSummaryModel.from_json(json_hash['summary']) if json_hash['summary']
      image_info = CopyleaksAiImageDetectionImageInfoModel.from_json(json_hash['imageInfo']) if json_hash['imageInfo']
      scanned_document = CopyleaksAiImageDetectionScannedDocumentModel.from_json(json_hash['scannedDocument']) if json_hash['scannedDocument']
      if json_hash['detectedObjects'].is_a?(Array)
        detected_objects = json_hash['detectedObjects'].map { |o| CopyleaksAiImageDetectedObjectModel.from_json(o) }
      end

      new(
        model: json_hash['model'],
        result: result,
        summary: summary,
        image_info: image_info,
        scanned_document: scanned_document,
        is_ai_detected: json_hash['isAiDetected'],
        detected_objects: detected_objects,
        error: Error.from_json(json_hash['error']),
        developer_payload: json_hash['developerPayload']
      )
    end

    def to_json(*args)
      hash = {
        'model' => @model,
        'result' => @result ? JSON.parse(@result.to_json) : nil,
        'summary' => @summary ? JSON.parse(@summary.to_json) : nil,
        'imageInfo' => @image_info ? JSON.parse(@image_info.to_json) : nil,
        'scannedDocument' => @scanned_document ? JSON.parse(@scanned_document.to_json) : nil
      }
      hash['isAiDetected'] = @is_ai_detected unless @is_ai_detected.nil?
      hash['detectedObjects'] = @detected_objects.map { |o| JSON.parse(o.to_json) } unless @detected_objects.nil?
      hash['error'] = JSON.parse(@error.to_json) unless @error.nil?
      hash['developerPayload'] = @developer_payload unless @developer_payload.nil?
      hash.to_json(*args)
    end
  end
end