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
  class Alerts
    attr_reader :category, :code, :title, :message, :help_link, :severity, :additional_data

    def initialize(category:, code:, title:, message:, help_link:, severity:, additional_data:)
      raise 'Copyleaks::Alerts - category must be a String' unless category.is_a?(String)
      raise 'Copyleaks::Alerts - code must be a String' unless code.is_a?(String)
      raise 'Copyleaks::Alerts - title must be a String' unless title.is_a?(String)
      raise 'Copyleaks::Alerts - message must be a String' unless message.is_a?(String)
      raise 'Copyleaks::Alerts - help_link must be a String' unless help_link.is_a?(String)
      raise 'Copyleaks::Alerts - severity must be a String' unless severity.is_a?(String)
      raise 'Copyleaks::Alerts - additional_data must be a String' unless additional_data.is_a?(String)

      @category = category
      @code = code
      @title = title
      @message = message
      @help_link = help_link
      @severity = severity
      @additional_data = additional_data
    end

    def as_json(*_args)
      {
        category: @category,
        code: @code,
        title: @title,
        message: @message,
        helpLink: @help_link,
        severity: @severity,
        additionalData: @additional_data
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end