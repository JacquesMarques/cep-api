# frozen_string_literal: true

# AccessTokensController responsible for create access token for users
class AccessTokensController < ApplicationController
  before_action :authenticate_user, only: :destroy
  before_action :authenticate_client, only: :create

  def create
    user = User.find_by!(email: login_params[:email], status: :active)

    if user.authenticate(login_params[:password])
      AccessToken.find_by(user: user).try(:destroy)

      access_token = AccessToken.create(user: user, api_key: api_key)
      token = access_token.generate_token

      params[:embed] = if params[:embed].present?
                         params[:embed].prepend('user,')
                       else
                         'user'
                       end
      render serialize(access_token, { token: token }).merge(status: :created)
    else
      render status: :unprocessable_entity,
             json: { error: { message: 'Invalid credentials.' } }
    end
  end

  def destroy
    access_token.destroy
    render status: :no_content
  end

  private

  def login_params
    params.require(:data).permit(:email, :password)
  end
end
