require 'spec_helper'

RSpec.describe CopyleaksApi::Validators::CustomFieldsValidator do
  subject { described_class }

  describe '#validate!' do
    it 'raises error if any key is invalid' do
      key = '1' * 129
      fields = { key => 'asd' }
      expect { subject.validate!(fields) }.to raise_error(CopyleaksApi::BadCustomFieldError, 'Key is too long')
    end

    it 'raises error if any value is invalid' do
      value = '1' * 513
      fields = { 'key' => value }
      expect { subject.validate!(fields) }.to raise_error(CopyleaksApi::BadCustomFieldError, 'Value is too long')
    end

    it 'raises error if all data is too long' do
      fields = 1500.times.each_with_object({}) { |e, o| o["key#{e}".to_sym] = e }
      expect { subject.validate!(fields) }
        .to raise_error(CopyleaksApi::BadCustomFieldError, 'Overall size is too large')
    end
  end
end
