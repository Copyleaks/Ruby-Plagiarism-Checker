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
  class SubmissionSensitiveData
    # @param [Boolean] driversLicense - Mask driver's license numbers from the scanned document with # characters. Available for users on a plan for 2500 pages or more.
    # @param [Boolean] credentials - Mask credentials from the scanned document with # characters. Available for users on a plan for 2500 pages or more.
    # @param [Boolean] passport - Mask passports from the scanned document with # characters. Available for users on a plan for 2500 pages or more.
    # @param [Boolean] network - Mask network identifiers from the scanned document with # characters. Available for users on a plan for 2500 pages or more.
    # @param [Boolean] url - Mask url from the scanned document with # characters. Available for users on a plan for 2500 pages or more.
    # @param [Boolean] emailAddress - Mask email addresses from the scanned document with # characters. Available for users on a plan for 2500 pages or more.
    # @param [Boolean] creditCard - Mask credit card numbers and credit card track numbers from the scanned document with # characters. Available for users on a plan for 2500 pages or more.
    # @param [Boolean] phoneNumber - Mask phone numbers from the scanned document with # characters. Available for users on a plan for 2500 pages or more.
    def initialize(
      driversLicense = false,
      credentials = false,
      passport = false,
      network = false,
      url = false,
      emailAddress = false,
      creditCard = false,
      phoneNumber = false
    )
      @driversLicense = driversLicense
      @credentials = credentials
      @passport = passport
      @network = network
      @url = url
      @emailAddress = emailAddress
      @creditCard = creditCard
      @phoneNumber = phoneNumber
    end

    def as_json(*_args)
      {
        driversLicense: @driversLicense,
        credentials: @credentials,
        passport: @passport,
        network: @network,
        url: @url,
        emailAddress: @emailAddress,
        creditCard: @creditCard,
        phoneNumber: @phoneNumber
      }.select { |_k, v| !v.nil? }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
