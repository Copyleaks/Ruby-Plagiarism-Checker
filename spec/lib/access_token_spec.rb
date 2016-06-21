require 'spec_helper'
require 'time'

RSpec.describe CopyleaksApi::AccessToken do
  subject { described_class.new(email, key) }

  before { stub_login }

  let(:email) { 'email@com.ua' }
  let(:key) { 'key' }

  describe '#fresh?' do
    it 'returns true if now is less then expire_at' do
      expire = DateTime.parse('2016-06-21T16:31:42Z')
      allow(DateTime).to receive(:now) { expire - 60 }
      expect(subject.fresh?).to be true
    end
  end

  describe '#login' do
    before { subject.login }
    it 'properly sets token' do
      expect(subject.token).to eq('ahzHhBCsFt3C0n9TNkZq07ZHqgFyinxy-OedPYMU4I1EUBNzfBtB8rZILmFxPMEd3_NnKzHhKZu_ootsMKxUCuL8v6Jal6iEefVX_rRbEMoSBc-QR0Q_3DCncR_ydiUfb1YgQg3DXywov8eyi4MPpSzI7TAX6w5WRRNlODEwu6_K1TzolcKTR5ate8vWt6o7r0RiPdA2FGN5yj_QYizuOyugTJzgpAit6hI8f3MNJE7RLtbFg46TDKqJi3yaEffJPLwOu6JFcahIe0_22MJOI7CNmBYuvzjly-tcn3jmH7TZFtrpiM42ELKMFO1qX2wSDBSh5XRmNYnuNbKw5Twp4SqT61t5d5AmEtlMAGm97T0WSGj0J8JhGXhIA4yoqPLo_hmXnzQZ9XbfyttpQ4zlMuu5N-ji4UNUgUS8kwibzLETWn3afMWWUN4eeO-zYM5USvH6sv47Mn3LjD7IEbqW9qFes8g')
    end

    it 'properly sets created_at' do
      expect(subject.created_at).to eq(DateTime.parse('2016-06-19T16:31:42Z'))
    end

    it 'properly sets expire_at' do
      expect(subject.expire_at).to eq(DateTime.parse('2016-06-21T16:31:42Z'))
    end
  end
end
