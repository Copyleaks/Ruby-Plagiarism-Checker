require 'spec_helper'

RSpec.describe CopyleaksApi::Validators::EmailValidator do
  subject { described_class }

  describe '#validate!' do
    it 'raises error if email is invalid' do
      expect { subject.validate!('email@a@.com') }.to raise_error(CopyleaksApi::BadEmailError)
    end

    it 'does not raise error if emails is valid' do
      expect { subject.validate!('email@test.com') }.not_to raise_error
    end
  end
end
