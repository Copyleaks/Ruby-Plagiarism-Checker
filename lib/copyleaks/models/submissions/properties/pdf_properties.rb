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
  class SubmissionPDF
    # @param [Boolean] create Add a request to generate a customizable export of the scan report, in a pdf format. Set to true in order to generate a pdf report for this scan.
    # @param [String] title Customize the title for the PDF report.
    # @param [String] largeLogo Customize the logo image in the PDF report.
    # @param [Boolean] rtl When set to true the text in the report will be aligned from right to left.
    # @param [SubmissionPdfVersion] verion  - PDF version to generate.
    # @param [SubmissionPdfColors] colors - Customizable colors.
    # @param [String] reportVersion - PDF report version to generate. Overrides version when both are supplied.
    #   Possible values: 'v1', 'v2', 'v3', 'latest'. Values are lowercase and case-sensitive ('V3' is rejected).
    #   Only takes effect when create is true.
    #   Leave nil to omit the field and get the server default.

    def initialize(
      create,
      title,
      largeLogo,
      rtl,
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
