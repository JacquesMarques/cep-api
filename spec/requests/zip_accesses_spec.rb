require 'rails_helper'

RSpec.describe 'ZipAccesses', type: :request do
  include_context 'Skip Auth'

  let(:first_zip) { create(:zip_access, { zipcode: '74590690' }) }
  let(:second_zip) { create(:zip_access, { zipcode: '74120130' }) }
  let(:third_zip) { create(:zip_access, { zipcode: '74230170' }) }

  # Putting them in an array make it easier to create them in one line
  let(:companies) { [first_zip, second_zip, third_zip] }

  let(:json_body) { JSON.parse(response.body) }

  describe 'GET /api/v1/companies' do
    before { companies }

    context 'default behavior' do
      before { get '/api/v1/companies' }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'receives a json with the "data" root key' do
        expect(json_body['data']).to_not be nil
      end

      it 'receives all 3 companies' do
        expect(json_body['data'].size).to eq 3
      end
    end
  end
end
