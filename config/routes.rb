Rails.application.routes.draw do
  scope '/api' do
    resources :import, only: [:create]

    resources :bottles, only: [:index] do
      get :week, on: :collection
    end

    resources :solids,  only: [:index] do
      get :week, on: :collection
    end

    get '/medications/pamol/week' => 'medications#pamol_week'
  end
end
