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
  class CopyleaksStartRequestModel
    attr_reader :trigger, :errorHandling

    # @param string[] trigger A list of scans that you submitted for a check-credits scan and that you would like to submit for a full scan.
    # @param CopyleaksStartErrorHandlings errorHandling When set to ignore (ignore = 1) the trigger scans will start running even if some of them are in error mode, when set to cancel (cancel = 0) the request will be cancelled if any error was found.
    def initialize(trigger, errorHandling = CopyleaksStartErrorHandlings::IGNORE)
      trigger.each do |item|
        unless item.instance_of?(String)
          raise 'Copyleaks::CopyleaksStartRequestModel - trigger - entity must be of type String'
        end
      end

      unless [0, 1].include? errorHandling
        raise 'Copyleaks::CopyleaksStartRequestModel - errorHandling - errorHandling must be of type Copyleaks::CopyleaksStartErrorHandlings Consts'
      end

      @trigger = trigger
      @errorHandling = errorHandling
    end

    def as_json(*_args)
      {
        trigger: @trigger,
        errorHandling: @errorHandling
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end

  class CopyleaksStartErrorHandlings
    # The request will be cancelled if any error was found.
    CANCEL = 0
    # The trigger scans will start running even if some of them are in error mode
    IGNORE = 1
  end
end
