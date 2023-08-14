Rails.application.routes.draw do
  get 'zip_accesses/index'
  scope :api do
    scope :v1 do
      resources :access_tokens, only: :create do
        delete '/', action: :destroy, on: :collection
      end
      resources :zip_accesses, only: [:index, :show]
    end
  end
end
