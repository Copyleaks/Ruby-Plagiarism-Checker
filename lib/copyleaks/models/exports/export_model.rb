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
  class CopyleaksExportModel
    attr_reader :completionWebhook, :results, :crawledVersion, :pdfReport, :maxRetries, :developerPayload

    # @param [String] completionWebhook This webhook event is triggered once the export is completed.
    # @param [ExportResults[]] results An array of results to be exported. The equivalent of downloading results manually.
    # @param [ExportCrawledVersion crawledVersion Download the crawled version of the submitted text. The equivalent of downloading crawled version manually.
    # @param [ExportPdfReport] pdfReport Download the PDF report. Allowed only when `properties.pdf.create` was set to true on the scan submittion.
    # @param [Integer] maxRetries How many retries to send before giving up. Using high value (12) may lead to a longer time until the completionWebhook being executed. A low value (1) may lead to errors while your service is temporary having problems.
    # @param [String] developerPayload Add a custom developer payload that will then be provided on the Export-Completed webhook. https://api.copyleaks.com/documentation/v3/webhooks/export-completed
    def initialize(completionWebhook, results, crawledVersion, pdfReport = nil, maxRetries = nil, developerPayload = nil)
      unless completionWebhook.instance_of?(String)
        raise 'Copyleaks::CopyleaksExportModel - completionWebhook - completionWebhook must be of type String'
      end

      results.each do |item|
        unless item.instance_of?(ExportResults)
          raise 'Copyleaks::CopyleaksExportModel - results - entity must be of type Copyleaks::ExportResults'
        end
      end

      unless crawledVersion.instance_of?(ExportCrawledVersion)
        raise 'Copyleaks::CopyleaksExportModel - crawledVersion - crawledVersion must be of type Copyleaks::ExportCrawledVersion'
      end

      if !pdfReport.nil? && pdfReport.instance_of?(ExportPdfReport)
        raise 'Copyleaks::CopyleaksExportModel - pdfReport - pdfReport must be of type Copyleaks::ExportPdfReport'
      end

      if !maxRetries.nil? && maxRetries.instance_of?(Integer)
        raise 'Copyleaks::CopyleaksExportModel - maxRetries - maxRetries must be of type Integer'
      end

      if !developerPayload.nil? && developerPayload.instance_of?(String)
        raise 'Copyleaks::CopyleaksExportModel - developerPayload - developerPayload must be of type String'
      end

      @completionWebhook = completionWebhook
      @results = results
      @crawledVersion = crawledVersion
      @pdfReport = pdfReport
      @maxRetries = maxRetries
      @developerPayload = developerPayload
    end

    def as_json(*_args)
      {
        completionWebhook: @completionWebhook,
        results: @results,
        crawledVersion: @crawledVersion,
        pdfReport: @pdfReport,
        maxRetries: @maxRetries,
        developerPayload: @developerPayload
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
