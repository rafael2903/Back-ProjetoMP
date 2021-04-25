# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users

  post '/user/auth', to: 'users#login'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
