require 'rails_helper'

RSpec.describe 'ZipAccesses', type: :request do
  include_context 'Skip Auth'

  let(:first_zip) { create(:zip_access, { zipcode: '74590690' }) }
  let(:second_zip) { create(:zip_access, { zipcode: '74120130' }) }
  let(:third_zip) { create(:zip_access, { zipcode: '74230170' }) }

  # Putting them in an array make it easier to create them in one line
  let(:zips) { [first_zip, second_zip, third_zip] }

  let(:json_body) { JSON.parse(response.body) }

  describe 'GET /api/v1/zip_accesses' do
    context 'default behavior' do
      before do
        zips
        get '/api/v1/zip_accesses'
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'receives a json with the "data" root key' do
        expect(json_body['data']).to_not be nil
      end

      it 'receives all 3 zips' do
        expect(json_body['data'].size).to eq 3
      end
    end
  end

  describe 'GET /api/v1/zip_accesses:id' do
    let!(:resp) {
      {
        "cep": first_zip.zipcode,
        "uf": 'GO',
        "cidade": 'Goiânia',
        "bairro": 'Jardim Balneário Meia Ponte',
        "logradouro": 'Rua Ricardo Paranhos'
      }
    }

    before do
      stub_request(:get, "http://cep.la/#{first_zip.zipcode}")
        .to_return(
          status: 200,
          body: resp.to_json
        )
      get "/api/v1/zip_accesses/#{first_zip.zipcode}"
    end

    context 'with correct zip code' do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'add access on zip_access table' do
        expect(ZipAccess.count).to eq(2)
      end
    end
  end
end
