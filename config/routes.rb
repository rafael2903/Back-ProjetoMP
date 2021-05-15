# frozen_string_literal: true

Rails.application.routes.draw do
  resources :form_answers
  resources :user_has_forms
  resources :users
  resources :forms

  post '/user/auth', to: 'users#login'

  get '/respondents/:form_id', to: 'user_has_forms#respondents'

  get '/assigned/:id', to: 'user_has_forms#assigned'

  get '/create_for_me/:id', to: 'forms#create_for_me'

  get 'same_form/:id', to: 'form_answers#same_form'

  # Rota referente a estoria de usuario EU[16]
  post '/find_id', to: 'users#find_id'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
