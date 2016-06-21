require 'spec_helper'
require 'json'

def delete_json
  @delete_json ||= File.read(File.join(fixture_path, 'responses', 'delete.json'))
end

def login_json
  @login_json ||= File.read(File.join(fixture_path, 'responses', 'login.json'))
end

def amount_json
  @amount_json ||= File.read(File.join(fixture_path, 'responses', 'balance.json'))
end

def created_json
  @ocr_json ||= File.read(File.join(fixture_path, 'responses', 'create_by.json'))
end

def list_json
  @list_json ||= File.read(File.join(fixture_path, 'responses', 'list.json'))
end

def result_json
  @result_json ||= File.read(File.join(fixture_path, 'responses', 'result.json'))
end

def status_json
  @status_json ||= File.read(File.join(fixture_path, 'responses', 'status.json'))
end

RSpec.describe CopyleaksApi::CopyleaksCloud do
  let(:email) { 'test@email.com' }
  let(:api_key) { 'test_key' }
  let(:config) { CopyleaksApi::Config }

  subject { described_class.new(email, api_key) }

  before { stub_login }

  describe '#balance' do
    before { stub_api_request(:get, 'account/count-credits', 200, amount_json) }

    it 'returns account balance' do
      expect(subject.balance).to eq(3)
    end
  end

  describe '#create_by_url' do
    before { stub_api_request(:post, 'publisher/create-by-url', 200, created_json) }

    it 'returns CopyleaksProcess object' do
      expect(subject.create_by_url('http://example.org')).to be_a CopyleaksApi::CopyleaksProcess
    end
  end

  describe '#create_by_file' do
    before { stub_api_request(:post, 'publisher/create-by-file', 200, created_json) }

    let(:file_path) { File.join(fixture_path, 'files', 'lorem.txt') }

    it 'returns CopyleaksProcess object' do
      expect(subject.create_by_file(file_path)).to be_a CopyleaksApi::CopyleaksProcess
    end
  end

  describe '#create_by_ocr' do
    before { stub_api_request(:post, 'publisher/create-by-file-ocr?language=English', 200, created_json) }

    let(:file_path) { File.join(fixture_path, 'files', 'lorem.jpg') }

    it 'returns CopyleaksProcess object' do
      expect(subject.create_by_ocr(file_path)).to be_a CopyleaksApi::CopyleaksProcess
    end
  end

  describe '#create_by_text' do
    before { stub_api_request(:post, 'publisher/create-by-text', 200, created_json) }

    it 'returns CopyleaksProcess object' do
      expect(subject.create_by_text('some text here')).to be_a CopyleaksApi::CopyleaksProcess
    end
  end

  describe '#delete' do
    let(:id) { 'id' }
    before { stub_api_request(:delete, 'publisher/id/delete', 200, delete_json) }

    it 'returns true after delete' do
      expect(subject.delete(id)).to be true
    end
  end

  describe '#list' do
    before { stub_api_request(:get, 'publisher/list', 200, list_json) }

    it 'returns array of processes' do
      expect(subject.list.map(&:class).uniq).to eq([CopyleaksApi::CopyleaksProcess])
    end
  end

  describe '#status' do
    let(:id) { 'id' }
    before { stub_api_request(:get, 'publisher/id/status', 200, status_json) }

    it 'returns process object' do
      expect(subject.status(id)).to be_a CopyleaksApi::CopyleaksProcess
    end

    it 'returns hash if raw option is given' do
      expect(subject.status(id, raw: true)).to be_a Hash
    end
  end

  describe '#result' do
    let(:id) { 'id' }

    before { stub_api_request(:get, 'publisher/id/result', 200, result_json) }

    it 'returns process object' do
      expect(subject.result(id)).to be_a CopyleaksApi::CopyleaksProcess
    end

    it 'returns array of hashes if raw option is given' do
      response = subject.result(id, raw: true)
      expect(response.map(&:class).uniq).to eq([Hash])
    end
  end

  describe '#url_with_language' do
    it 'raises error if given language is not supported' do
      expect { subject.send(:url_with_language, 'action', language: 'asd') }
        .to raise_error CopyleaksApi::UnknownLanguageError
    end
  end
end
