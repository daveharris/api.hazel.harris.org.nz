Rails.application.routes.draw do
  scope '/api' do
    resources :import, only: [:index, :create]

    resources :bottles, only: [:index]
  end
end
