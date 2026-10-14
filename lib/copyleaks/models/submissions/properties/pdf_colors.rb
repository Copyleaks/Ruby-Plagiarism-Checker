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
    class SubmissionPdfColors
        attr_reader :mainStrip, :titles, :identical, :minorChanges, :relatedMeaning, :aiDetection, :writingFeedback

        # Every color is optional, in HEX format (for example '#040F21'). A color left nil is not sent.
        # @param [String] mainStrip - The color of the main strip in the header.
        # @param [String] titles - The color of titles in the PDF report. Sent as "titles".
        # @param [String] identical - The highlight color for identical matches.
        # @param [String] minorChanges - The highlight color for minor changes matches.
        # @param [String] relatedMeaning - The highlight color for related meaning matches.
        # @param [String] aiDetection - The highlight color for AI content detection.
        # @param [String] writingFeedback - The highlight color for writing feedback (Grammar Checker).
        def initialize(
            mainStrip = nil,
            titles = nil,
            identical = nil,
            minorChanges = nil,
            relatedMeaning = nil,
            aiDetection: nil,
            writingFeedback: nil
        )
            @mainStrip = mainStrip
            @titles = titles
            @identical = identical
            @minorChanges = minorChanges
            @relatedMeaning = relatedMeaning
            @aiDetection = aiDetection
            @writingFeedback = writingFeedback
        end

        # Earlier versions named the second argument title.
        def title
            @titles
        end

        def as_json(*_args)
            {
                mainStrip: @mainStrip,
                titles: @titles,
                identical: @identical,
                minorChanges: @minorChanges,
                relatedMeaning: @relatedMeaning,
                aiDetection: @aiDetection,
                writingFeedback: @writingFeedback
            }.select { |_k, v| !v.nil? }
        end

        def to_json(*options)
            as_json(*options).to_json(*options)
        end
    end
end
