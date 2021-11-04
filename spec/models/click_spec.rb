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
end
