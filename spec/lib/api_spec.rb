require 'spec_helper'
require 'net/http'

RSpec.describe CopyleaksApi::Api do
  subject { cloud.api }

  let(:config) { CopyleaksApi::Config }
  let(:token) { 'asd' }

  let(:user_email) { 'email@com.ua' }
  let(:key) { 'key' }
  let(:cloud) { CopyleaksApi::CopyleaksCloud.new(user_email, key) }

  before { stub_login }

  describe '#sandbox_header' do
    it 'sets headers if config is true' do
      config.sandbox_mode = true
      expect(subject.send(:sandbox_header)).to match('copyleaks-sandbox-mode' => '')
    end

    it 'returns empty hash if we dont use sandbox' do
      expect(subject.send(:sandbox_header)).to be_empty
    end
  end

  describe '#content_type_header' do
    let(:boundary) { 'some_bound' }

    it 'sets headers if boundary is set' do
      expect(subject.send(:content_type_header, boundary: boundary))
        .to eq('Content-Type' => "multipart/form-data; boundary=\"#{boundary}\"")
    end

    it 'does not set header is there is no boundary' do
      expect(subject.send(:content_type_header, {})).to eq('Content-Type' => 'application/json')
    end
  end

  describe '#partial_scan_header' do
    let(:header) { { 'copyleaks-allow-partial-scan' => '' } }

    it 'sets headers given option is true' do
      expect(subject.send(:partial_scan_header, allow_partial_scan: true)).to eq(header)
    end

    it 'does not set header if given option is false' do
      expect(subject.send(:partial_scan_header, allow_partial_scan: false)).to be_empty
    end

    it 'does not set header if no options is given and config one is set to false' do
      config.allow_partial_scan = false
      expect(subject.send(:partial_scan_header, {})).to be_empty
    end

    it 'set header if no options is given and config one is set to true' do
      config.allow_partial_scan = true
      expect(subject.send(:partial_scan_header, {})).to eq(header)
    end
  end

  describe '#authentication_header' do
    it 'sets headers if token is given' do
      expect(subject.send(:authentication_header, token: token)).to eq('Authorization' => "Bearer #{token}")
    end

    it 'does not set header is there is no token' do
      expect(subject.send(:authentication_header, {})).to be_empty
    end
  end

  describe '#http_callbacks_header' do
    let(:url) { 'http://some.com' }

    it 'sets headers if token is given' do
      expect(subject.send(:http_callbacks_header, token: token, http_callback: url))
        .to eq('copyleaks-http-callback' => url)
    end

    it 'does not set header if there is no argument given' do
      expect(subject.send(:http_callbacks_header, {})).to be_empty
    end

    it 'does not set header if there is no_callback given' do
      config.http_callback = url
      expect(subject.send(:http_callbacks_header, no_callbacks: true)).to be_empty
    end
  end

  describe '#email_callback_header' do
    let(:email) { 'my@email.com' }

    it 'sets headers if token is given' do
      expect(subject.send(:email_callback_header, email_callback: email))
        .to eq('copyleaks-email-callback' => email)
    end

    it 'does not set header if there is no argument given' do
      expect(subject.send(:email_callback_header, {})).to be_empty
    end

    it 'does not set header if there is no_callback given' do
      config.email_callback = email
      expect(subject.send(:email_callback_header, no_callbacks: true)).to be_empty
    end
  end

  describe '#custom_field_headers' do
    let(:custom_fields) { { some_message: 'asdasd' } }
    let(:header) { { 'copyleaks-client-custom-some_message' => 'asdasd' } }

    it 'sets headers if they are given' do
      expect(subject.send(:custom_field_headers, custom_fields: custom_fields)).to eq(header)
    end

    it 'does not set header if given "no_custom_fields" parameter' do
      config.custom_fields = custom_fields
      expect(subject.send(:custom_field_headers, no_custom_fields: true)).to be_empty
    end

    it 'sets custom fields from configurations' do
      config.custom_fields = custom_fields
      expect(subject.send(:custom_field_headers, {})).to eq(header)
    end
  end

  describe '#gather_headers' do
    let(:request) { Net::HTTP::Post.new('/path') }
    let(:options) { { token: token } }

    it 'gather all headers together in one hash' do
      subject.send(:gather_headers, request, options)
      expect(request['Authorization']).to eq("Bearer #{options[:token]}")
    end

    it 'calls all methods' do
      [:http_callbacks_header, :email_callback_header, :authentication_header, :content_type_header,
      :partial_scan_header].each do |method|
        expect(subject).to receive(method).with(options) { {} }
      end
      expect(subject).to receive(:sandbox_header) { {} }
      subject.send(:gather_headers, request, options)
    end
  end
end
