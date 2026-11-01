module Copyleaks
  class SubmissionSensitiveData
    # Each flag masks that kind of data in the scanned document with # characters (creditCard also masks track
    # numbers). Needs a plan of 2500 pages or more. Arguments left nil are not sent (server default: false).
    def initialize(
      driversLicense = nil,
      credentials = nil,
      passport = nil,
      network = nil,
      url = nil,
      emailAddress = nil,
      creditCard = nil,
      phoneNumber = nil
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
