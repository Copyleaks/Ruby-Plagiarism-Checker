require 'spec_helper'
require 'net/http'

RSpec.describe CopyleaksApi::Validators::UrlValidator do
  subject { described_class }

  describe '@validate!' do
    it 'raises error if url is invalid' do
      expect { subject.validate!('http:/broken.323') }.to raise_error CopyleaksApi::BadUrlError
    end

    it 'not raises error if url is valid' do
      expect { subject.validate!('http://broken.com') }.not_to raise_error
    end
  end
end
