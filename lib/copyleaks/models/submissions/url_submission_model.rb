module Copyleaks
  class CopyleaksURLSubmissionModel < CopyleaksSubmissionModel
    VERBS = %w[GET POST PUT].freeze

    attr_reader :url, :verb, :headers

    # @param [String] verb HTTP method Copyleaks uses to fetch the url: 'GET', 'POST' or 'PUT' (server default: GET).
    # @param [Array<Array<String>>] headers Sent when Copyleaks fetches the url, e.g. [['Cookie', 'session=abc']].
    #   When set, Copyleaks does not add its own default headers.
    def initialize(url, properties, verb: nil, headers: nil)
      raise 'Copyleaks::CopyleaksURLSubmissionModel - url - url must be of type String' unless url.instance_of?(String)
      unless properties.instance_of?(SubmissionProperties)
        raise 'Copyleaks::CopyleaksURLSubmissionModel - properties - properties must be of type SubmissionProperties'
      end
      if !verb.nil? && !VERBS.include?(verb)
        raise "Copyleaks::CopyleaksURLSubmissionModel - verb - verb must be one of #{VERBS.join(', ')}"
      end
      unless Utils.headers_valid?(headers)
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
