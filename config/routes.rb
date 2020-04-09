Rails.application.routes.draw do
  resources :members
  resources :camdram_shows, only: [:index] do
    get 'check', on: :collection
  end
end
