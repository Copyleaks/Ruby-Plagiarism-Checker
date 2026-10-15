module Copyleaks
  class SubmissionPDF
    # Arguments left nil are not sent, so the server default applies.
    # @param [Boolean] create Generate a PDF report for this scan.
    # @param [String] largeLogo The logo image in the PDF report.
    # @param [Boolean] rtl Align the report text right to left.
    # @param [SubmissionPdfVersion] version Deprecated: use reportVersion.
    # @param [String] reportVersion See SubmissionPdfReportVersion. Overrides version; applies only when create is true.
    def initialize(
      create = nil,
      title = nil,
      largeLogo = nil,
      rtl = nil,
      version = nil,
      colors = nil,
      reportVersion = nil
    )

      if !colors.nil? && !colors.instance_of?(SubmissionPdfColors)
        raise 'Copyleaks::SubmissionPDF - colors - colors must be of type SubmissionPdfColors'
      end
      if !reportVersion.nil? && !reportVersion.instance_of?(String)
        raise 'Copyleaks::SubmissionPDF - reportVersion - reportVersion must be of type String'
      end

      @create = create
      @title = title
      @largeLogo = largeLogo
      @rtl = rtl
      @version = version
      @colors = colors
      @reportVersion = reportVersion
    end

    def as_json(*_args)
      {
        create: @create,
        title: @title,
        largeLogo: @largeLogo,
        rtl: @rtl,
        version: @version,
        colors: @colors,
        reportVersion: @reportVersion
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
