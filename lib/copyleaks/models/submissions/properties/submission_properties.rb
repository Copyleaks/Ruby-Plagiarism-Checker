module Copyleaks
  # Scan settings. Only webhooks is required; arguments left nil are not sent, so the server default applies.
  class SubmissionProperties
    attr_reader :webhooks, :includeHtml, :developerPayload, :sandbox, :expiration, :sensitivityLevel, :cheatDetection,
                :action, :author, :filters, :scanning, :indexing, :exclude, :pdf, :sensitiveDataProtection, :scanMethodAlgorithm,
                :aiGeneratedText, :customMetadata, :writingFeedback, :displayLanguage, :aiSourceMatch,
                :overview, :internalAiSourceMatch, :references, :scanTimeZone, :course, :assignment, :institution

    # @param [String] developerPayload Echoed in the webhooks, at most 512 characters.
    # @param [Boolean] sandbox Free mock results for testing the integration. Turn it off in production.
    # @param [Integer] expiration Hours the scan is kept before it is deleted, 1 to 2880 (server default 2880).
    # @param [Integer] sensitivityLevel 1 (fastest) to 5 (slowest, finds the smallest matches); server default 3.
    # @param [Boolean] cheatDetection Check for cheating; a detection adds a scan alert to the completed webhook.
    # @param [SubmissionCustomMetadata] customMetadata Attached to your document in a Copyleaks repository.
    # @param [String] displayLanguage PDF report language: 'en', 'es', 'pt', 'fr', 'de' or 'it', lowercase and
    #   case-sensitive. Only applies when pdf.create is true (server default 'en').
    # @param [String] scanTimeZone IANA time zone for the scan time on the PDF report, e.g. 'America/New_York'.
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
