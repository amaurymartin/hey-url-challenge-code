# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Urls', type: :request do
  describe 'POST /urls' do
    before { post urls_path, params: params }

    context 'with valid params' do
      let(:params) do
        {
          url: { original_url: 'http://example.com' }
        }
      end

      it { expect(response).to have_http_status :redirect }
    end

    context 'with invalid params' do
      let(:params) do
        {
          url: { original_url: 'invalid' }
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to urls_path
      end
    end
  end
end
