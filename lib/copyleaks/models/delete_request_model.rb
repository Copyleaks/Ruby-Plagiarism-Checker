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
require 'json'
module Copyleaks
  class CopyleaksDeleteRequestModel
    attr_reader :scans, :purge, :completionWebhook

    # @param [Array] scans The list of scans to delete
    # @param [Boolean] purge Delete all trace of the scan from Copyleaks server, including from internal database. A purged process will not be available as a result for previous scans.
    # @param [String] completionWebhook Allows you to register to a webhook that will be fired once the removal has been completed. Make sure that your endpoint is listening to a POST method (no body parameters were supplied).
    def initialize(scans, purge = false, completionWebhook = '')
      scans.each do |object_id|
        unless object_id.instance_of?(IdObject)
          raise 'Copyleaks::CopyleaksDeleteRequestModel - scans - entity must be of type Copyleaks::IdObject'
        end
      end

      unless [true, false].include? purge
        raise 'Copyleaks::CopyleaksDeleteRequestModel - purge - purge must be of type Boolean'
      end

      unless completionWebhook.instance_of?(String)
        raise 'Copyleaks::CopyleaksDeleteRequestModel - completionWebhook - completionWebhook must be of type String'
      end

      @scans = scans
      @purge = purge
      @completionWebhook = completionWebhook
    end

    def as_json(*_args)
      {
        scans: @scans.map { |object_id| object_id.as_json },
        purge: @purge,
        completionWebhook: @completionWebhook
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
