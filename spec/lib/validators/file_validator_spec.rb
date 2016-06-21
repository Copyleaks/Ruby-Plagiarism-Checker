require 'spec_helper'

RSpec.describe CopyleaksApi::Validators::FileValidator do
  subject { described_class }

  describe '#validate_ocr!' do
    it 'raises error if file extension is not supported' do
      expect { subject.validate_ocr!('file.oooc') }.to raise_error(CopyleaksApi::BadFileError)
    end

    it 'does not raise error if all is ok' do
      expect { subject.validate_ocr!(File.join(fixture_path, 'files', 'lorem.jpg')) }.not_to raise_error
    end
  end

  describe '#validate_text_file!' do
    it 'raises error if file extension is not supported' do
      expect { subject.validate_text_file!('file.oooc') }.to raise_error(CopyleaksApi::BadFileError)
    end

    it 'does not raise error if all is ok' do
      expect { subject.validate_text_file!(File.join(fixture_path, 'files', 'lorem.txt')) }.not_to raise_error
    end
  end

  describe '#file_extension' do
    let(:file) { 'file.txt' }

    it 'returns correct extension' do
      expect(subject.send(:file_extension, file)).to eq(:txt)
    end
  end
end
