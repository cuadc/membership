Rails.application.routes.draw do
  resources :members do
    get 'ballot_list', on: :collection
    get 'mailing_list', on: :collection
    get 'import', on: :collection
  end

  resources :camdram_shows, only: [:index] do
    get 'check', on: :collection
  end

  get '/login' => 'sessions#new', as: :login
  get '/logout' => 'sessions#destroy', as: :logout
  get '/auth/:provider/callback' => 'sessions#create', as: :auth_callback
  get '/auth/failure' => 'sessions#failure', as: :auth_failure
end
