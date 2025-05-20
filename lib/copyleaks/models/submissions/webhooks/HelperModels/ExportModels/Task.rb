 #The MIT License(MIT)
 #Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
 #Permission is hereby granted, free of charge, to any person obtaining a copy
 #of this software and associated documentation files (the "Software"), to deal
 #in the Software without restriction, including without limitation the rights
 #to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 #copies of the Software, and to permit persons to whom the Software is
 #furnished to do so, subject to the following conditions:
 #The above copyright notice and this permission notice shall be included in all
 #copies or substantial portions of the Software.
 #THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 #IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 #FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
 #AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 #LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 #OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 #SOFTWARE.
 #=

module Copyleaks
  class Task
    attr_reader :endpoint, :is_healthy, :http_status_code

    # @param [String] endpoint - The API endpoint being checked.
    # @param [Boolean] is_healthy - Whether the task/endpoint is healthy.
    # @param [Integer] http_status_code - The returned HTTP status code.
    def initialize(endpoint:, is_healthy:, http_status_code:)
      raise 'Copyleaks::Task - endpoint must be a String' unless endpoint.is_a?(String)
      raise 'Copyleaks::Task - is_healthy must be a Boolean' unless [true, false].include?(is_healthy)
      raise 'Copyleaks::Task - http_status_code must be an Integer' unless http_status_code.is_a?(Integer)

      @endpoint = endpoint
      @is_healthy = is_healthy
      @http_status_code = http_status_code
    end

    def as_json(*_args)
      {
        endpoint: @endpoint,
        isHealthy: @is_healthy,
        httpStatusCode: @http_status_code
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end