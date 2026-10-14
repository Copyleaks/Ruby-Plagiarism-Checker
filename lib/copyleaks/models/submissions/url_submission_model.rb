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
  class CopyleaksURLSubmissionModel < CopyleaksSubmissionModel
    VERBS = %w[GET POST PUT].freeze

    attr_reader :url, :verb, :headers

    # @param [String] url The url to be scanned
    # @param [SubmissionProperties] properties Check inner properties for more details.
    # @param [String] verb The HTTP method Copyleaks uses to fetch the url: 'GET', 'POST' or 'PUT'.
    #   Leave nil to omit the field (server default: GET).
    # @param [Array<Array<String>>] headers Headers Copyleaks sends when it fetches the url, for example
    #   [['Cookie', 'session=abc']]. When set, Copyleaks does not add its own default headers.
    def initialize(url, properties, verb: nil, headers: nil)
      raise 'Copyleaks::CopyleaksURLSubmissionModel - url - url must be of type String' unless url.instance_of?(String)
      unless properties.instance_of?(SubmissionProperties)
        raise 'Copyleaks::CopyleaksURLSubmissionModel - properties - properties must be of type SubmissionProperties'
      end
      if !verb.nil? && !VERBS.include?(verb)
        raise "Copyleaks::CopyleaksURLSubmissionModel - verb - verb must be one of #{VERBS.join(', ')}"
      end
      unless headers.nil? || (headers.instance_of?(Array) && headers.all? { |pair| pair.instance_of?(Array) && pair.length == 2 && pair.all? { |part| part.instance_of?(String) } })
        raise 'Copyleaks::CopyleaksURLSubmissionModel - headers - headers must be an Array of String Array pairs'
      end

      super(properties)
      @url = url
      @verb = verb
      @headers = headers
    end

    def as_json(*_args)
      {
        url: @url,
        verb: @verb,
        headers: @headers,
        properties: @properties
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
