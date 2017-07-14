Rails.application.routes.draw do
  scope '/api' do
    resources :import, only: [:index, :create]

    resources :bottles, only: [:index] do
      get :week, on: :collection
    end

    resources :solids,  only: [:index] do
      get :week, on: :collection
    end

    get '/medication/pamol/week' => 'medication#pamol_week'
  end
end
