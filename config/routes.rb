Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :access_tokens, only: :create do
        delete '/', action: :destroy, on: :collection
      end
    end
  end
end
