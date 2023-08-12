# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmbedPicker' do
  let(:first_user) { create(:user) }
  let(:second_user) { create(:admin) }
  let(:third_user) { create(:other_user) }
  let(:users) { [first_user, second_user, third_user] }
  let(:access_token) { create(:access_token, user: first_user) }
  let(:access_token_two) { create(:access_token, user: first_user) }

  let(:params) { {} }
  let(:embed_picker) { EmbedPicker.new(presenter) }

  describe '#embed' do
    context 'with access token (many-to-one) as the resource' do
      let(:presenter) { AccessTokenPresenter.new(access_token, params) }

      before do
        allow(AccessTokenPresenter).to(
          receive(:relations).and_return(['user'])
        )
      end

      context 'with no "embed" parameter' do
        it 'returns the "data" hash without changing it' do
          expect(embed_picker.embed.data).to eq presenter.data
        end
      end

      context 'with invalid relation "something"' do
        let(:params) { { embed: 'something' } }

        it 'raises a "RepresentationBuilderError"' do
          expect { embed_picker.embed }.to raise_error(RepresentationBuilderError)
        end
      end

      context 'with the "embed" parameter containing "user"' do
        let(:params) { { embed: 'user' } }

        it 'embeds the "user" data' do
          expect(embed_picker.embed.data[:user]).to eq({
                                                         'id' => first_user.id,
                                                         'email' => 'john@example.com',
                                                         'uuid' => first_user.uuid,
                                                         'given_name' => 'John',
                                                         'family_name' => 'Doe',
                                                         'role' => 'user',
                                                         'last_logged_in_at' => nil,
                                                         'confirmed_at' => nil,
                                                         'confirmation_sent_at' => nil,
                                                         'reset_password_sent_at' => nil,
                                                         'created_at' => first_user.created_at,
                                                         'updated_at' => first_user.updated_at,
                                                         'confirmation_token' => first_user.confirmation_token,
                                                         'confirmation_redirect_url' => nil,
                                                         'reset_password_redirect_url' => nil,
                                                         'reset_password_token' => nil
                                                       })
        end
      end

      context 'with the "embed" parameter containing "user"' do
        let(:params) { { embed: 'access_tokens' } }
        let(:presenter) { UserPresenter.new(first_user, params) }

        before do
          access_token && access_token_two
          allow(UserPresenter).to(
            receive(:relations).and_return(['access_tokens'])
          )
        end

        it 'embeds the "user" data' do
          expect(embed_picker.embed.data[:access_tokens].size).to eq(2)
          expect(embed_picker.embed.data[:access_tokens].first['id']).to eq(
            access_token.id
          )
          expect(embed_picker.embed.data[:access_tokens].last['id']).to eq(
            access_token_two.id
          )
        end
      end
    end
  end
end
