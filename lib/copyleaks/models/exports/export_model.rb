module Copyleaks
  class CopyleaksExportModel
    attr_reader :completionWebhook, :completionWebhookHeaders, :results, :crawledVersion, :pdfReport, :maxRetries,
                :developerPayload, :aiDetection, :writingFeedback, :overview

    # Only completionWebhook is required. Request at least one artifact to export.
    # @param [String] completionWebhook Called once the export is completed.
    # @param [ExportPdfReport] pdfReport Allowed only when properties.pdf.create was true on the scan.
    # @param [Integer] maxRetries Upload retries before giving up. A high value (12) can delay the completion
    #   webhook; a low value (1) can fail while your service has a temporary problem.
    # @param [String] developerPayload Echoed in the Export-Completed webhook.
    # @param [Array] completionWebhookHeaders Headers added to the completion webhook.
    def initialize(completionWebhook, results = nil, crawledVersion = nil, pdfReport = nil, maxRetries = nil,
                   developerPayload = nil, completionWebhookHeaders = nil,
                   aiDetection: nil, writingFeedback: nil, overview: nil)
      unless completionWebhook.instance_of?(String)
        raise 'Copyleaks::CopyleaksExportModel - completionWebhook - completionWebhook must be of type String'
      end

      unless header_format_valid?(completionWebhookHeaders)
        raise 'Copyleaks::CopyleaksExportModel - completionWebhookHeaders - completionWebhookHeaders must be an Array of String Array pairs'
      end

      unless results.nil? || (results.is_a?(Array) && results.all? { |item| item.instance_of?(ExportResults) })
        raise 'Copyleaks::CopyleaksExportModel - results - entity must be of type Copyleaks::ExportResults'
      end

      if !crawledVersion.nil? && !crawledVersion.instance_of?(ExportCrawledVersion)
        raise 'Copyleaks::CopyleaksExportModel - crawledVersion - crawledVersion must be of type Copyleaks::ExportCrawledVersion'
      end

      if !pdfReport.nil? && !pdfReport.instance_of?(ExportPdfReport)
        raise 'Copyleaks::CopyleaksExportModel - pdfReport - pdfReport must be of type Copyleaks::ExportPdfReport'
      end

      if !maxRetries.nil? && !maxRetries.instance_of?(Integer)
        raise 'Copyleaks::CopyleaksExportModel - maxRetries - maxRetries must be of type Integer'
      end

      if !developerPayload.nil? && !developerPayload.instance_of?(String)
        raise 'Copyleaks::CopyleaksExportModel - developerPayload - developerPayload must be of type String'
      end

      if !aiDetection.nil? && !aiDetection.instance_of?(ExportAiDetection)
        raise 'Copyleaks::CopyleaksExportModel - aiDetection - aiDetection must be of type Copyleaks::ExportAiDetection'
      end

      if !writingFeedback.nil? && !writingFeedback.instance_of?(ExportWritingFeedback)
        raise 'Copyleaks::CopyleaksExportModel - writingFeedback - writingFeedback must be of type Copyleaks::ExportWritingFeedback'
      end

      if !overview.nil? && !overview.instance_of?(ExportOverview)
        raise 'Copyleaks::CopyleaksExportModel - overview - overview must be of type Copyleaks::ExportOverview'
      end

      @completionWebhook = completionWebhook
      @completionWebhookHeaders = completionWebhookHeaders
      @results = results
      @crawledVersion = crawledVersion
      @pdfReport = pdfReport
      @maxRetries = maxRetries
      @developerPayload = developerPayload
      @aiDetection = aiDetection
      @writingFeedback = writingFeedback
      @overview = overview
    end

    def as_json(*_args)
      {
        completionWebhook: @completionWebhook,
        completionWebhookHeaders: @completionWebhookHeaders,
        results: @results,
        crawledVersion: @crawledVersion,
        pdfReport: @pdfReport,
        aiDetection: @aiDetection,
        writingFeedback: @writingFeedback,
        overview: @overview,
        maxRetries: @maxRetries,
        developerPayload: @developerPayload
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    private

    def header_format_valid?(header)
      return true if header.nil?
      return false unless header.instance_of?(Array)

      header.all? do |pair|
        pair.instance_of?(Array) && pair.length == 2 && pair[0].instance_of?(String) && pair[1].instance_of?(String)
      end
    end
  end
end
