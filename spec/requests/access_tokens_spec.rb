require 'rails_helper'

RSpec.describe 'AccessTokens', type: :request do
  let!(:user) {create(:user)}

  describe 'POST /api/v1/access_tokens' do
    let(:key) { ApiKey.create }
    let(:headers) do
      { 'HTTP_AUTHORIZATION' =>
          "CepApi-Token api_key=#{key.id}:#{key.key}" }
    end
    before { post '/api/v1/access_tokens', params: params, headers: headers }

    context 'with existing user' do

      context 'with valid password' do
        let(:params) { { data: { email: user.email, password: 'password' } } }

        it 'gets HTTP status 201 Created' do
          expect(response.status).to eq 201
        end

        it 'receives an access token' do
          expect(json_body['data']['token']).to_not be nil
        end

        it 'receives the user embedded' do
          expect(json_body['data']['user']['id']).to eq user.id
        end
      end

      context 'with invalid password' do
        let(:params) { { data: { email: user.email, password: 'fake'  } } }

        it 'returns 422 Unprocessable Entity' do
          expect(response.status).to eq 422
        end
      end
    end

    context 'with nonexistent user' do
      let(:params) { { data: { email: 'unknown', password: 'fake'  } } }

      it 'gets HTTP status 404 Not Found' do
        expect(response.status).to eq 404
      end
    end
  end

  describe 'DELETE /api/v1/access_tokens' do

    context 'with valid API key' do
      let(:api_key) { ApiKey.create }
      let(:api_key_str) { "#{api_key.id}:#{api_key.key}" }

      before do
        delete '/api/v1/access_tokens', headers: headers
      end

      context 'with valid access token' do
        let(:access_token) { create(:access_token, api_key: api_key, user: user) }
        let(:token) { access_token.generate_token }
        let(:token_str) { "#{user.id}:#{token}" }

        let(:headers) do
          token =
            { 'HTTP_AUTHORIZATION' =>
                "CepApi-Token api_key=#{api_key_str}, access_token=#{token_str}" }
        end

        it 'returns 204 No Content' do
          expect(response.status).to eq 204
        end

        it 'destroys the access token' do
          expect(user.reload.access_tokens.size).to eq 0
        end
      end

      context 'with invalid access token' do
        let(:headers) do
          { 'HTTP_AUTHORIZATION' =>
              "CepApi-Token api_key=#{api_key_str}, access_token=1:fake" }
        end

        it 'returns 401' do
          expect(response.status).to eq 401
        end
      end
    end

    context 'with invalid API key' do
      it 'returns HTTP status 401' do
        delete '/api/v1/access_tokens', params: {}
        expect(response.status).to eq 401
      end
    end
  end
end
