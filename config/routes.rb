# frozen_string_literal: true

Rails.application.routes.draw do
  resources :form_answers
  resources :user_has_forms
  resources :users
  resources :forms

  post '/user/auth', to: 'users#login'

  get '/respondents/:id', to: 'user_has_forms#respondents'

  get '/create_for_me/:id', to: 'forms#create_for_me'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
