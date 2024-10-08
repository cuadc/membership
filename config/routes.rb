Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :members do
    get 'ballot_list', on: :collection
    get 'pending_verifications', on: :collection
    get 'pending_signups', on: :collection
    post 'link_signups', on: :collection
    get 'camdram_associations_needed', on: :collection
    get 'cards_needed', on: :collection
    post 'issue_card', on: :member
    put 'ingest/purchase', on: :collection
  end

  resources :camdram_shows, only: [:index] do
    get 'check', on: :collection
  end

  get '/login' => 'sessions#new', as: :login
  get '/logout' => 'sessions#destroy', as: :logout
  delete '/logout' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create', as: :auth_callback
  get '/auth/failure' => 'sessions#failure', as: :auth_failure

  get '/signup' => 'signup#new'
  post '/signup' => 'signup#create'
  get '/verify' => 'signup#verify'
  get '/pay' => 'signup#pay'

  get '/info' => 'misc#info'
  get '/cudar-optout' => 'misc#cudar_optout'
  delete '/cudar-resign' => 'misc#cudar_resign'
  get '/ping', to: ->(env) { [200, {}, ["pong\n"]] }
end
