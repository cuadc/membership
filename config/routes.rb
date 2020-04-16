Rails.application.routes.draw do
  resources :members do
    get 'ballot_list', on: :collection
  end
  resources :camdram_shows, only: [:index] do
    get 'check', on: :collection
  end
end
