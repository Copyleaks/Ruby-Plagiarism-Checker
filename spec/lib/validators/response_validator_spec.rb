require 'spec_helper'
require 'net/http'

RSpec.describe CopyleaksApi::Validators::ResponseValidator do
  subject { described_class }

  Response = Struct.new('Response', :code, :body)
  let(:response) do
    new = Response[200, '']
    allow(new).to receive(:[]) { |_| false }
    new
  end

  describe '#validate!' do
    let(:message) { 'Some Message' }
    let(:error_code) { 20 }

    it 'raises error if response has error code header' do
      allow(response).to receive(:[]) { |_| error_code }
      response.body = "{\"Message\":\"#{message}\"}"
      expect { subject.validate!(response) }
        .to raise_error(CopyleaksApi::ManagedError, "Error code: #{error_code}. #{message}")
    end

    it 'raises error with correct code' do
      begin
        allow(response).to receive(:[]) { |_| 20 }
        response.body = "{\"Message\":\"#{message}\"}"
        subject.validate!(response)
      rescue CopyleaksApi::ManagedError => e
        expect(e.code).to eq(20)
      end
    end

    it 'raises error if status code is bad' do
      response.code = 400
      expect { subject.validate!(response) }.to raise_error(CopyleaksApi::BadResponseError)
    end

    it 'does not raise error if all is ok' do
      expect { subject.validate!(response) }.not_to raise_error
    end
  end
end
