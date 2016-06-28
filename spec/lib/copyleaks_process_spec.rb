require 'spec_helper'
require 'time'
require 'json'

RSpec.describe CopyleaksApi::CopyleaksProcess do
  subject { described_class.new(cloud: cloud) }

  before { stub_login }

  let(:email) { 'email@com.ua' }
  let(:key) { 'key' }
  let(:cloud) { CopyleaksApi::CopyleaksCloud.new(email, key, :publisher) }
  let(:created_at) { DateTime.parse('19/06/2016 19:57:42') }
  let(:id) { '2fd7b9cc-bc8e-4dfd-b65d-61385dcaf941' }

  context 'class methods' do
    describe '#create' do
      subject { described_class.create(cloud, JSON.parse(created_json)) }
      it 'correctly creates from standard response' do
        expect(subject.process_id).to eq(id)
        expect(subject.created_at).to eq(created_at)
      end
    end

    describe '#create_from_status' do
      subject { described_class.create_from_status(cloud, id, JSON.parse(status_json)) }

      it 'correctly creates from status response' do
        expect(subject.process_id).to eq(id)
        expect(subject.status).to eq('finished')
        expect(subject.progress).to eq(100)
      end
    end

    describe '#create_from_result' do
      let(:json) { JSON.parse(result_json) }
      subject { described_class.create_from_result(cloud, id, json) }

      it 'correctly creates from result response' do
        expect(subject.process_id).to eq(id)
        expect(subject.result).to eq(json)
      end
    end

    describe '#create_from_list' do
      let(:json) { JSON.parse(list_json)[0] }
      subject { described_class.create_from_list(cloud, json) }

      it 'correctly creates from list response' do
        expect(subject.process_id).to eq('9b301fdb-5c09-438b-9bcd-28c9aeefa731')
        expect(subject.created_at).to eq(DateTime.parse('19/06/2016 16:51:35'))
        expect(subject.status).to eq('finished')
        expect(subject.custom_fields).to eq({})
      end
    end
  end
end
