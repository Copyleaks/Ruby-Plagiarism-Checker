module Copyleaks
  class SubmissionScanningExclude
    MAX_BACKLINKS_DOMAINS = 10
    MAX_TEXT_PHRASES = 5

    # @param [String] idPattern Exclude your submissions whose id matches from batch, internal database and
    #   repository results. Wildcards: '*' any characters, '.' one non-whitespace character.
    # @param [String[]] backlinksDomains Exclude results with backlinks to these domains: at most 10, 1-256 chars each.
    # @param [String[]] text Exclude results containing any of these phrases: at most 5, 1-30 chars each.
    def initialize(idPattern = nil, backlinksDomains: nil, text: nil)
      if !idPattern.nil? && !idPattern.instance_of?(String)
        raise 'Copyleaks::SubmissionScanningExclude - idPattern - idPattern must be of type String'
      end
      unless string_list_valid?(backlinksDomains, MAX_BACKLINKS_DOMAINS, 256)
        raise 'Copyleaks::SubmissionScanningExclude - backlinksDomains - backlinksDomains must be an Array of at most 10 Strings of 1 to 256 characters'
      end
      unless string_list_valid?(text, MAX_TEXT_PHRASES, 30)
        raise 'Copyleaks::SubmissionScanningExclude - text - text must be an Array of at most 5 Strings of 1 to 30 characters'
      end

      @idPattern = idPattern
      @backlinksDomains = backlinksDomains
      @text = text
    end

    def as_json(*_args)
      {
        idPattern: @idPattern,
        backlinksDomains: @backlinksDomains,
        text: @text
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    private

    def string_list_valid?(list, max_items, max_length)
      return true if list.nil?

      list.is_a?(Array) && list.length <= max_items &&
        list.all? { |item| item.is_a?(String) && item.length.between?(1, max_length) }
    end
  end
end
