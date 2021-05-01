# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users', type: :request do # rubocop:todo Metrics/BlockLength
  describe 'GET /index' do
    it 'renderiza resposta de sucesso' do
      User.create!({ email: 'pri@gmail.com', password: '123456' })
      get users_url, headers: { 'Content_Type': 'application/json' }, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renderiza resposta de sucesso' do
      user = User.create!({ email: 'pri@gmail.com', password: '123456' })
      get user_url(user), as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do # rubocop:todo Metrics/BlockLength
    context 'com parametros validos' do
      it 'cria um novo usuario' do
        expect do
          post users_url,
               params: { email: 'priscila@email.com', password: '123456' },
               headers: { 'Content_Type': 'application/json' }, as: :json
        end.to change(User, :count).by(1)
      end

      it 'renderiza JSON de sucesso ao criar um novo usuario' do
        post users_url,
             params: { email: 'priscila@email.com', password: '123456' },
             headers: { 'Content_Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'com parametros invalidos' do
      it 'nao cria um novo usuario' do
        expect do
          post users_url,
               params: { email: 'priscila@email.com', is_admin: false },
               headers: { 'Content_Type': 'application/json' }, as: :json
        end.to change(User, :count).by(0)
      end

      it 'renderiza JSON de erro ao nao criar um novo usuario' do
        post users_url,
             params: { email: 'priscila@email.com', is_admin: false },
             headers: { 'Content_Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PATCH /update' do # rubocop:todo Metrics/BlockLength
    context 'com parametros validos' do
      it 'atualiza parametros do usuario' do
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        patch user_url(user),
              params: { email: 'pri@gmail.com', password: '123456789' },
              headers: { 'Content_Type': 'application/json' }, as: :json
        user.reload
      end

      it 'renderiza JSON de sucesso ao atualizar um atributo' do
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        patch user_url(user),
              params: { email: 'pri@gmail.com', password: '123456789' },
              headers: { 'Content_Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'com parametros invalidos' do
      it 'renderiza JSON de erro ao atualizar atributo' do
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        patch user_url(user),
              # rubocop:todo Layout/LineLength
              params: { email: 'pri@gmail.com', password: nil }, headers: { 'Content_Type': 'application/json' }, as: :json
        # rubocop:enable Layout/LineLength
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deleta um usuario' do
      user = User.create!({ email: 'pri@gmail.com', password: '123456' })
      expect do
        delete user_url(user), headers: { 'Content_Type': 'application/json' }, as: :json
      end.to change(User, :count).by(-1)
    end
  end

  describe 'LOGIN /login' do
    it 'renderiza mensagem de sucesso' do
      User.create!({ email: 'pri@gmail.com', password: '123456' })
      get '/user/auth', params: { email: 'pri@gmail.com', password: '123456' },
                        headers: { 'Content_Type': 'application/json' }, as: :json
      expect(response).to be_successful
    end

    it 'renderiza mensagem de nao autorizado' do
      User.create!({ email: 'pri@gmail.com', password: '123456' })
      get '/user/auth', params: { email: 'pri@gmail.com', password: '12345678' },
                        headers: { 'Content_Type': 'application/json' }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
