# frozen_string_literal: true

# TESTES referente a estoria de usuario "EU 10"
require 'rails_helper'

RSpec.describe '/user_has_forms', type: :request do
  describe 'GET /index' do
    it 'renderiza resposta de sucesso' do
      user = User.create!({ email: 'pri@gmail.com', password: '123456' })
      form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                            user_id: user.id })
      UserHasForm.create!({ user_id: user.id, form_id: form.id })
      get user_has_forms_url, headers: { 'Content-Type': 'application/json' },
                              as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renderiza resposta de sucesso' do
      user = User.create!({ email: 'pri@gmail.com', password: '123456' })
      form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                            user_id: user.id })
      user_has_form = UserHasForm.create!({ user_id: user.id, form_id: form.id })
      get user_has_form_url(user_has_form), as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'com parametros validos' do
      it 'adiciona um novo respondente' do
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: user.id })
        expect do
          post user_has_forms_url,
               params: { user_id: user.id, form_id: form.id },
               headers: { 'Content-Type': 'application/json' },
               as: :json
        end.to change(UserHasForm, :count).by(1)
      end

      it 'renderiza resposta JSON de sucesso quando adiciona um novo respondente' do
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: user.id })
        post user_has_forms_url,
             params: { user_id: user.id, form_id: form.id },
             headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'com parametros invalidos' do
      it 'nao adiciona um novo respondente' do
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: user.id })
        expect do
          post user_has_forms_url,
               params: { user_id: '1', form_id: form.id }, as: :json
        end.to change(UserHasForm, :count).by(0)
      end

      it 'renderiza resposta JSON com erro ao adicionar um novo respondente' do
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: user.id })
        post user_has_forms_url,
             params: { user_id: '1', form_id: form.id },
             headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PATCH /update' do
    context 'com parametros validos' do
      it 'atualiza id do respondente' do
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: user.id })
        new_user = User.create!({ email: 'priscila@gmail.com', password: '123456' })
        user_has_form = UserHasForm.create!({ user_id: user.id, form_id: form.id })
        patch user_has_form_url(user_has_form),
              params: { user_id: new_user.id, form_id: form.id },
              headers: { 'Content-Type': 'application/json' }, as: :json
        user_has_form.reload
      end

      it 'renderiza resposta JSON quando atualiza um atributo' do
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: user.id })
        new_user = User.create!({ email: 'priscila@gmail.com', password: '123456' })
        user_has_form = UserHasForm.create!({ user_id: user.id, form_id: form.id })
        patch user_has_form_url(user_has_form),
              params: { form_id: form.id, user_id: new_user.id },
              headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'com parametros invalidos' do
      it 'renderiza resposta de erro' do
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: user.id })
        user_has_form = UserHasForm.create!({ user_id: user.id, form_id: form.id })
        patch user_has_form_url(user_has_form),
              params: { user_id: '1', form_id: form.id },
              headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deleta um respondente' do
      user = User.create!({ email: 'pri@gmail.com', password: '123456' })
      form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                            user_id: user.id })
      user_has_form = UserHasForm.create!({ user_id: user.id, form_id: form.id })
      expect do
        delete user_has_form_url(user_has_form),
               headers: { 'Content-Type': 'application/json' }, as: :json
      end.to change(UserHasForm, :count).by(-1)
    end
  end

  describe 'RESPONDENTS /respondents' do
    it 'renderiza todos com form_id iguais' do
      user1 = User.create!({ email: 'pri@email.com', password: '123456' })
      user2 = User.create!({ email: 'pri@hotmail.com', password: '123456' })
      user3 = User.create!({ email: 'pri@gmail.com', password: '123456' })
      creator = User.create!({ email: 'priscila@gmail.com', password: '123456' })
      form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                            user_id: creator.id })
      UserHasForm.create!({ user_id: user1.id, form_id: form.id })
      UserHasForm.create!({ user_id: user2.id, form_id: form.id })
      UserHasForm.create!({ user_id: user3.id, form_id: form.id })
      get '/respondents/:id', as: :json
      expect(response).to be_successful
    end

    it 'renderiza JSON de sucesso ao retornar todos com form_id iguais' do
      user1 = User.create!({ email: 'pri@email.com', password: '123456' })
      user2 = User.create!({ email: 'pri@hotmail.com', password: '123456' })
      user3 = User.create!({ email: 'pri@gmail.com', password: '123456' })
      creator = User.create!({ email: 'priscila@gmail.com', password: '123456' })
      form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                            user_id: creator.id })
      UserHasForm.create!({ user_id: user1.id, form_id: form.id })
      UserHasForm.create!({ user_id: user2.id, form_id: form.id })
      UserHasForm.create!({ user_id: user3.id, form_id: form.id })
      get '/respondents/283', as: :json
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(a_string_including('application/json'))
    end
  end
end
