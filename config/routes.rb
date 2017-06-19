Rails.application.routes.draw do
  resources :import, only: [:index, :create]
end
