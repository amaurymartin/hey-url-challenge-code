# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  subject(:click) { build(:click) }

  describe '#validate' do
    before { click.validate }

    it { is_expected.to be_valid }

    context 'when url is nil' do
      subject(:click) { build(:click, url: nil) }

      it { is_expected.to be_invalid }
    end

    context 'when url browser is blank' do
      subject(:click) { build(:click, browser: '') }

      it { is_expected.to be_invalid }
    end

    context 'when url platform is blank' do
      subject(:click) { build(:click, platform: '') }

      it { is_expected.to be_invalid }
    end
  end

  describe '.on_current_month' do
    subject(:on_current_month) { Click.on_current_month }

    before do
      travel_to(1.month.ago) { create_list(:click, 2) }
      create_list(:click, 3)
    end

    it { expect(on_current_month.count).to eq 3 }
  end

  describe '.count_daily_clicks' do
    subject(:count_daily_clicks) { Click.count_daily_clicks }

    before do
      travel_to(2.day.ago) { create_list(:click, 1) }
      travel_to(1.day.ago) { create_list(:click, 2) }
      create_list(:click, 3)
    end

    it :aggregate_failures do
      expect(count_daily_clicks.keys).to include(
        2.day.ago.to_date, 1.day.ago.to_date, Date.today
      )
      expect(count_daily_clicks.values).to include(1, 2, 3)
    end
  end

  describe '.count_by_browser' do
    subject(:count_by_browser) { Click.count_by_browser }

    let(:browsers) { %w[Chrome Firefox] }

    before do
      browsers.each_with_index do |browser, i|
        create_list(:click, i + 1, browser: browser)
      end
    end

    it :aggregate_failures do
      expect(count_by_browser.keys).to include(*browsers)
      expect(count_by_browser.values).to include(1, 2)
    end
  end

  describe '.count_by_platform' do
    subject(:count_by_platform) { Click.count_by_platform }

    let(:platforms) { %w[Linux Windows] }

    before do
      platforms.each_with_index do |platform, i|
        create_list(:click, i + 1, platform: platform)
      end
    end

    it :aggregate_failures do
      expect(count_by_platform.keys).to include(*platforms)
      expect(count_by_platform.values).to include(1, 2)
    end
  end
end
