# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  subject(:url) { build(:url) }

  describe '#validate' do
    before { url.validate }

    it { is_expected.to be_valid }

    context 'when original_url is blank' do
      subject(:url) { build(:url, original_url: '') }

      it { is_expected.to be_invalid }
    end

    context 'when original_url is invalid' do
      subject(:url) { build(:url, original_url: 'invalid') }

      it { is_expected.to be_invalid }
    end

    context 'when short_url is blank' do
      subject(:url) { build(:url, short_url: '') }

      it { is_expected.to be_valid }
    end

    context 'when short_url is already taken' do
      subject(:url) { build(:url, short_url: existing_url.short_url) }

      let(:existing_url) { create(:url) }

      it { is_expected.to be_invalid }
    end
  end

  describe '#visit!' do
    before { url.save }

    it :aggregate_failures do
      expect { url.visit!('Chrome', 'Generic Linux') }
        .to change(url, :clicks_count).by(1)
      expect { url.visit!('Chrome', 'Generic Linux') }
        .to change(Click, :count).by(1)
    end
  end

  describe '.latest' do
    subject(:latest) { described_class.latest }

    let!(:url_list) { create_list(:url, 15) }

    it :aggregate_failures do
      expect(latest.count).to eq 10
      expect(latest.first).to eq url_list.last
    end
  end
end
