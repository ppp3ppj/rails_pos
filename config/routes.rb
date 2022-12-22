Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # TODO check unmatched
  namespace :api do
    namespace :v1 do
       namespace :user do
         post 'sign_in', to: 'sessions#sign_in'
         delete 'sign_out', to: 'sessions#sign_out'
         get 'me', to: 'sessions#me'
       end
       get 'example', to: 'example#index'
       resources :foods
    end
  end

  # set root get status 200
  root to: proc { [200, {}, ['']] }
end
