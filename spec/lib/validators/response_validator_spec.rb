require 'spec_helper'
require 'net/http'

RSpec.describe CopyleaksApi::Validators::ResponseValidator do
  subject { described_class }

  Response = Struct.new('Response', :code, :body)

  before do
    @response = Response[200, '']
    allow(@response).to receive(:[]) { |_| false }
  end

  describe '#validate!' do
    let(:message) { 'Some Message' }

    it 'raises error if response has error code header' do
      allow(@response).to receive(:[]) { |_| 20 }
      @response.body = "{\"Message\":\"#{message}\"}"
      expect { subject.validate!(@response) }.to raise_error(CopyleaksApi::ManagedError)
    end

    it 'raises error if status code is bad' do
      @response.code = 400
      expect { subject.validate!(@response) }.to raise_error(CopyleaksApi::BadResponseError)
    end

    it 'does not raise error if all is ok' do
      expect { subject.validate!(@response) }.not_to raise_error
    end
  end
end
