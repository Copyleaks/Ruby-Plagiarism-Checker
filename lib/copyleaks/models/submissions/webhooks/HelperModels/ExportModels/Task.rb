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
    attr_reader :endpoint, :isHealthy, :httpStatusCode

    # @param [String] endpoint - The endpoint address of the export task.
    # @param [Boolean] isHealthy - This flag gives an indication whether the scan was completed without internal errors on the Copyleaks side.
    # @param [Integer] httpStatusCode - The status code reported by the customer servers. If the tasks.isHealthy is equal to false - this field will be null.
    def initialize(endpoint:, isHealthy:, httpStatusCode:)
      raise 'Copyleaks::Task - endpoint must be a String' unless endpoint.is_a?(String)
      raise 'Copyleaks::Task - isHealthy must be a Boolean' unless [true, false].include?(isHealthy)
      raise 'Copyleaks::Task - httpStatusCode must be an Integer' unless httpStatusCode.is_a?(Integer)

      @endpoint = endpoint
      @isHealthy = isHealthy
      @httpStatusCode = httpStatusCode
    end

    def as_json(*_args)
      {
        endpoint: @endpoint,
        isHealthy: @isHealthy,
        httpStatusCode: @httpStatusCode
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end