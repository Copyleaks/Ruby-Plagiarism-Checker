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
  class SubmissionProperties
    attr_reader :webhooks, :includeHtml, :developerPayload, :sandbox, :expiration, :sensitivityLevel, :cheatDetection,
                :action, :author, :filters, :scanning, :indexing, :exclude, :pdf, :sensitiveDataProtection, :scanMethodAlgorithm,
                :aiGeneratedText, :customMetadata, :writingFeedback, :displayLanguage, :aiSourceMatch,
                :overview, :internalAiSourceMatch, :references, :scanTimeZone, :course, :assignment, :institution

    # Only webhooks is required. Every other argument is optional: a value left nil is not sent,
    # and the server default applies.
    #
    # @param [SubmissionWebhooks] webhooks - Check inner properties for more details.
    # @param [Boolean] includeHtml - By default, Copyleaks will present the report in text format. If set to true, Copyleaks will also include html format.
    # @param [String] developerPayload - Add custom developer payload that will then be provided on the webhooks (at most 512 characters).
    # @param [Boolean] sandbox - You can test the integration with the Copyleaks API for free using the sandbox mode. You will be able to submit content for a scan and get back mock results, simulating the way Copyleaks will work to make sure that you successfully integrated with the API. Turn off this feature on production environment.
    # @param [Integer] expiration - Specify the maximum life span of a scan in hours on the Copyleaks servers (1 to 2880, server default: 2880). When expired, the scan will be deleted and will no longer be accessible.
    # @param [Integer] sensitivityLevel - You can control the level of plagiarism sensitivity that will be identified according to the speed of the scan. If you prefer a faster scan with the results that contains the highest amount of plagiarism choose 1, and if a slower, more comprehensive scan, that will also detect the smallest instances choose 5 (server default: 3).
    # @param [Boolean] cheatDetection - When set to true the submitted document will be checked for cheating. If a cheating will be detected, a scan alert will be added to the completed webhook.
    # @param [SubmissionActions] action - Types of content submission actions. Possible values: Scan: Start scan immediately. Check Credits: Check how many credits will be used for this scan. Index Only: Only index the file in the Copyleaks internal database. No credits will be used.
    # @param [SubmissionAuthor] author - Check inner properties for more details.
    # @param [SubmissionFilter] filters - Check inner properties for more details.
    # @param [SubmissionScanning] scanning - Check inner properties for more details.
    # @param [SubmissionIndexing] indexing - Check inner properties for more details.
    # @param [SubmissionExclude] exclude - Check inner properties for more details.
    # @param [SubmissionPDF] pdf - Check inner properties for more details.
    # @param [SubmissionSensitiveData] sensitiveDataProtection - Check inner properties for more details.
    # @param [SubmissionScanMethodAlgorithm] scanMethodAlgorithm - Check inner properties for more details.
    # @param [SubmissionAiGeneratedText] aiGeneratedText - Check inner properties for more details.
    # @param [SubmissionCustomMetadata] customMetadata - Add custom properties that will be attached to your document in a Copyleaks repository.
    # @param [SubmissionWritingFeedback] writingFeedback - Check inner properties for more details.
    # @param [String] displayLanguage - The language the PDF report is generated in.
    #   Possible values: 'en', 'es', 'pt', 'fr', 'de', 'it'. Values are lowercase and case-sensitive ('EN' and 'en-US' are rejected).
    #   Only takes effect when pdf.create is true.
    #   Leave nil to omit the field and get the server default ('en').
    # @param [SubmissionAiSourceMatch] aiSourceMatch - Check inner properties for more details.
    #   AI Source Match currently only applies to documents detected as English.
    #   Leave nil to omit the field and get the server default (disabled).
    #
    # Keyword options:
    # @param [SubmissionOverview] overview - Gen-AI Overview: key insights from the scan data.
    # @param [SubmissionInternalAiSourceMatch] internalAiSourceMatch - Find sources in the Copyleaks internal AI database.
    # @param [SubmissionReferences] references - Citation Checker: validate the references in the text.
    # @param [String] scanTimeZone - IANA time zone name for the scan time on the PDF report, for example 'America/New_York'.
    # @param [SubmissionCourse] course - Course identifier, used for tracking analytics.
    # @param [SubmissionAssignment] assignment - Assignment identifier, used for tracking analytics.
    # @param [SubmissionInstitution] institution - Institution identifier, used for tracking analytics.
    def initialize(
      webhooks, includeHtml = nil, developerPayload = nil, sandbox = nil, expiration = nil,
      sensitivityLevel = nil, cheatDetection = nil, action = nil, author = nil, filters = nil,
      scanning = nil, indexing = nil, exclude = nil, pdf = nil, sensitiveDataProtection = nil,
      scanMethodAlgorithm = nil, aiGeneratedText = nil, customMetadata = nil, writingFeedback = nil,
      displayLanguage = nil, aiSourceMatch = nil,
      overview: nil, internalAiSourceMatch: nil, references: nil, scanTimeZone: nil,
      course: nil, assignment: nil, institution: nil
    )
      unless webhooks.instance_of?(SubmissionWebhooks)
        raise 'Copyleaks::SubmissionProperties - webhooks - webhooks must be of type SubmissionWebhooks'
      end
      if !includeHtml.nil? && ![true, false].include?(includeHtml)
        raise 'Copyleaks::SubmissionProperties - includeHtml - includeHtml must be of type Boolean'
      end
      if !developerPayload.nil? && !developerPayload.instance_of?(String)
        raise 'Copyleaks::SubmissionProperties - developerPayload - developerPayload must be of type String'
      end
      if !sandbox.nil? && ![true, false].include?(sandbox)
        raise 'Copyleaks::SubmissionProperties - sandbox - sandbox must be of type Boolean'
      end
      if !expiration.nil? && !expiration.instance_of?(Integer)
        raise 'Copyleaks::SubmissionProperties - expiration - expiration must be of type Integer'
      end
      if !sensitivityLevel.nil? && !sensitivityLevel.instance_of?(Integer)
        raise 'Copyleaks::SubmissionProperties - sensitivityLevel - sensitivityLevel must be of type Integer'
      end
      if !cheatDetection.nil? && ![true, false].include?(cheatDetection)
        raise 'Copyleaks::SubmissionProperties - cheatDetection - cheatDetection must be of type Boolean'
      end
      if !action.nil? && ![0, 1, 2].include?(action)
        raise 'Copyleaks::SubmissionProperties - action - action must be of type SubmissionActions consts'
      end
      if !author.nil? && !author.instance_of?(SubmissionAuthor)
        raise 'Copyleaks::SubmissionProperties - author - author must be of type SubmissionAuthor'
      end
      if !filters.nil? && !filters.instance_of?(SubmissionFilter)
        raise 'Copyleaks::SubmissionProperties - filters - filters must be of type SubmissionFilter'
      end
      if !scanning.nil? && !scanning.instance_of?(SubmissionScanning)
        raise 'Copyleaks::SubmissionProperties - scanning - scanning must be of type SubmissionScanning'
      end
      if !indexing.nil? && !indexing.instance_of?(SubmissionIndexing)
        raise 'Copyleaks::SubmissionProperties - indexing - indexing must be of type SubmissionIndexing'
      end
      if !exclude.nil? && !exclude.instance_of?(SubmissionExclude)
        raise 'Copyleaks::SubmissionProperties - exclude - exclude must be of type SubmissionExclude'
      end
      if !pdf.nil? && !pdf.instance_of?(SubmissionPDF)
        raise 'Copyleaks::SubmissionProperties - pdf - pdf must be of type SubmissionPDF'
      end
      if !sensitiveDataProtection.nil? && !sensitiveDataProtection.instance_of?(SubmissionSensitiveData)
        raise 'Copyleaks::SubmissionProperties - sensitiveDataProtection - sensitiveDataProtection must be of type SubmissionSensitiveData'
      end
      if !scanMethodAlgorithm.nil? && ![0, 1].include?(scanMethodAlgorithm)
        raise 'Copyleaks::SubmissionProperties - scanMethodAlgorithm - scanMethodAlgorithm must be of type SubmissionScanMethodAlgorithm'
      end
      if !aiGeneratedText.nil? && !aiGeneratedText.instance_of?(SubmissionAiGeneratedText)
        raise 'Copyleaks::SubmissionProperties - aiGeneratedText - aiGeneratedText must be of type SubmissionAiGeneratedText'
      end
      if !customMetadata.nil? && !(customMetadata.is_a?(Array) && customMetadata.all? { |element| element.is_a?(SubmissionCustomMetadata) })
        raise 'Copyleaks::SubmissionProperties - customMetadata - customMetadata must be of type SubmissionCustomMetadata[]'
      end
      if !writingFeedback.nil? && !writingFeedback.instance_of?(SubmissionWritingFeedback)
        raise 'Copyleaks::SubmissionProperties - writingFeedback - writingFeedback must be of type SubmissionWritingFeedback'
      end
      if !displayLanguage.nil? && !displayLanguage.instance_of?(String)
        raise 'Copyleaks::SubmissionProperties - displayLanguage - displayLanguage must be of type String'
      end
      if !aiSourceMatch.nil? && !aiSourceMatch.instance_of?(SubmissionAiSourceMatch)
        raise 'Copyleaks::SubmissionProperties - aiSourceMatch - aiSourceMatch must be of type SubmissionAiSourceMatch'
      end
      if !overview.nil? && !overview.instance_of?(SubmissionOverview)
        raise 'Copyleaks::SubmissionProperties - overview - overview must be of type SubmissionOverview'
      end
      if !internalAiSourceMatch.nil? && !internalAiSourceMatch.instance_of?(SubmissionInternalAiSourceMatch)
        raise 'Copyleaks::SubmissionProperties - internalAiSourceMatch - internalAiSourceMatch must be of type SubmissionInternalAiSourceMatch'
      end
      if !references.nil? && !references.instance_of?(SubmissionReferences)
        raise 'Copyleaks::SubmissionProperties - references - references must be of type SubmissionReferences'
      end
      if !scanTimeZone.nil? && !scanTimeZone.instance_of?(String)
        raise 'Copyleaks::SubmissionProperties - scanTimeZone - scanTimeZone must be of type String'
      end
      if !course.nil? && !course.instance_of?(SubmissionCourse)
        raise 'Copyleaks::SubmissionProperties - course - course must be of type SubmissionCourse'
      end
      if !assignment.nil? && !assignment.instance_of?(SubmissionAssignment)
        raise 'Copyleaks::SubmissionProperties - assignment - assignment must be of type SubmissionAssignment'
      end
      if !institution.nil? && !institution.instance_of?(SubmissionInstitution)
        raise 'Copyleaks::SubmissionProperties - institution - institution must be of type SubmissionInstitution'
      end

      @webhooks = webhooks
      @includeHtml = includeHtml
      @developerPayload = developerPayload
      @sandbox = sandbox
      @expiration = expiration
      @sensitivityLevel = sensitivityLevel
      @cheatDetection = cheatDetection
      @aiGeneratedText = aiGeneratedText
      @action = action
      @author = author
      @filters = filters
      @scanning = scanning
      @indexing = indexing
      @exclude = exclude
      @pdf = pdf
      @sensitiveDataProtection = sensitiveDataProtection
      @scanMethodAlgorithm = scanMethodAlgorithm
      @customMetadata = customMetadata
      @writingFeedback = writingFeedback
      @displayLanguage = displayLanguage
      @aiSourceMatch = aiSourceMatch
      @overview = overview
      @internalAiSourceMatch = internalAiSourceMatch
      @references = references
      @scanTimeZone = scanTimeZone
      @course = course
      @assignment = assignment
      @institution = institution
    end

    def as_json(*_args)
      {
        webhooks: @webhooks,
        includeHtml: @includeHtml,
        developerPayload: @developerPayload,
        sandbox: @sandbox,
        expiration: @expiration,
        sensitivityLevel: @sensitivityLevel,
        cheatDetection: @cheatDetection,
        aiGeneratedText: @aiGeneratedText,
        action: @action,
        author: @author,
        course: @course,
        assignment: @assignment,
        institution: @institution,
        filters: @filters,
        scanning: @scanning,
        indexing: @indexing,
        exclude: @exclude,
        pdf: @pdf,
        sensitiveDataProtection: @sensitiveDataProtection,
        scanMethodAlgorithm: @scanMethodAlgorithm,
        customMetadata: @customMetadata,
        writingFeedback: @writingFeedback,
        displayLanguage: @displayLanguage,
        scanTimeZone: @scanTimeZone,
        aiSourceMatch: @aiSourceMatch,
        internalAiSourceMatch: @internalAiSourceMatch,
        overview: @overview,
        references: @references
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
