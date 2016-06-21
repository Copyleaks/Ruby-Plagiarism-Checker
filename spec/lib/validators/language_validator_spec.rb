require 'spec_helper'

RSpec.describe CopyleaksApi::Validators::LanguageValidator do
  subject { described_class }

  describe '#validate!' do
    it 'raises error if given language is not supported' do
      expect { subject.validate!('Tibet') }.to raise_error(CopyleaksApi::UnknownLanguageError)
    end

    it 'does not raise error if all is ok' do
      expect { subject.validate!(CopyleaksApi::Language.english) }.not_to raise_error
    end
  end
end
