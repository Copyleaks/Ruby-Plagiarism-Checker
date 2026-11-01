module Copyleaks
    class SubmissionPdfColors
        attr_reader :mainStrip, :titles, :identical, :minorChanges, :relatedMeaning, :aiDetection, :writingFeedback

        # Optional HEX colors, e.g. '#040F21'; nil colors are not sent. identical, minorChanges, relatedMeaning,
        # aiDetection and writingFeedback (Grammar Checker) are highlight colors.
        # @param [String] mainStrip The main strip in the header.
        # @param [String] titles Sent as "titles".
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
