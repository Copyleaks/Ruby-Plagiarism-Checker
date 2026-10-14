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
  class SubmissionScanningExclude
    MAX_BACKLINKS_DOMAINS = 10
    MAX_TEXT_PHRASES = 5

    # @param [String] idPattern Exclude your submissions from results if their id matches the supplied pattern. Matched submissions will be excluded from batch, internal database and repositories results.
    # * Supported pattern wildcards for idPattern:
    # * * '*' Matches any, zero or more, characters.
    # * * '.' Matches a single (non whitespace) character
    # @param [String[]] backlinksDomains Exclude results that contain backlinks to these domains.
    #   At most 10 domains, each 1 to 256 characters.
    # @param [String[]] text Exclude results that contain any of these phrases. At most 5 phrases, each 1 to 30 characters.
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
