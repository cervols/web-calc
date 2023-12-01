require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'Client Authentication' do
    let(:expression) { '4+3' }

    before { get '/', headers: headers, params: { expression: expression } }

    context 'with invalid authentication scheme' do
      let(:headers) { { Authorization: '' } }

      it 'returns HTTP status 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid authentication scheme' do
      let(:headers) do
        {
          Authorization: "Token token=#{api_key.id}:#{api_key.access_token}"
        }
      end

      context 'with invalid token' do
        let(:api_key) { OpenStruct.new(id: 1, key: SecureRandom.hex) }

        it 'returns HTTP status 401 Unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with valid token' do
        let(:api_key) { create(:api_key) }

        it 'returns HTTP status 200' do
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
