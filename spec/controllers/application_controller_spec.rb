require 'rails_helper'

RSpec.describe 'get response from unmatched route', type: :request do
  it 'responds with 404 status' do
    get '/not_found_route'

    expect(response).to have_http_status(:not_found)
    expect(api_response['error']).to eq('not found')
  end
end
