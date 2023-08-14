class ZipAccessesController < ApplicationController
  before_action :authenticate_user

  BASE_URL = 'http://cep.la'.freeze

  def index
    zip_accesses = orchestrate_query(ZipAccess.all)
    render serialize(zip_accesses)
  end

  def show
    url = "#{BASE_URL}/#{params[:id]}"
    response = Rails.cache.fetch([url], expires: 2.days) do
      HTTParty.get(url, headers: { 'cache-control': 'no-cache', 'Accept': 'application/json' })
    end

    if response.present?
      save_access(response)
      render json: response
    else
      render json: { message: 'Zip not found' }, status: :not_found
    end
  end

  private

  def save_access(response)
    ZipAccess.create(
      zipcode: response['cep'],
      state: response['uf'],
      city: response['cidade'],
      neighborhood: response['bairro'],
      street: response['logradouro'],
      user_id: current_user.id
    )
  end
end
