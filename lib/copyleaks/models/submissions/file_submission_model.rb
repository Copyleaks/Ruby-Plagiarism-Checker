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
  class CopyleaksFileSubmissionModel < CopyleaksSubmissionModel
    # @param [String] base64 A base64 data string of a file. If you would like to scan plain text, encode it as base64 and submit it.
    # @param [String] filename The name of the file as it will appear in the Copyleaks scan report Make sure to include the right extension for your filetype.
    # @param [SubmissionProperties] properties Check inner properties for more details.
    def initialize(base64, filename, properties)
      unless base64.instance_of?(String)
        raise 'Copyleaks::CopyleaksFileSubmissionModel - base64 - base64 must be of type String'
      end
      unless filename.instance_of?(String)
        raise 'Copyleaks::CopyleaksFileSubmissionModel - filename - filename must be of type String'
      end
      unless properties.instance_of?(SubmissionProperties)
        raise 'Copyleaks::CopyleaksFileSubmissionModel - properties - properties must be of type SubmissionProperties'
      end

      super(properties)
      @base64 = base64
      @filename = filename
    end

    def as_json(*_args)
      {
        base64: @base64,
        filename: @filename,
        properties: @properties
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
