# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/form_answers', type: :request do # rubocop:todo Metrics/BlockLength
  describe 'GET /index' do
    it 'renderiza resposta de sucesso' do
      creator = User.create!({ email: 'pri@gmail.com', password: '123456' })
      form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                            user_id: creator.id })
      respondent = User.create!({ email: 'pri@email.com', password: '123456' })
      FormAnswer.create!({ answers: [{ questao1: 'resposta1', questao2: 'resposta2' }],
                           user_id: respondent.id, form_id: form.id })
      get form_answers_url, headers: { 'Content-Type': 'application/json' }, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renderiza resposta de sucesso' do
      creator = User.create!({ email: 'pri@gmail.com', password: '123456' })
      form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                            user_id: creator.id })
      respondent = User.create!({ email: 'pri@email.com', password: '123456' })
      form_answer = FormAnswer.create!({ answers: [{ questao1: 'resposta1',
                                                     questao2: 'resposta2' }],
                                         user_id: respondent.id,
                                         form_id: form.id })
      get form_answer_url(form_answer), as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do # rubocop:todo Metrics/BlockLength
    context 'com parametros validos' do
      it 'cria nova resposta a um formulario' do
        creator = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: creator.id })
        respondent = User.create!({ email: 'pri@email.com', password: '123456' })
        expect do
          post form_answers_url,
               params: { answers: [{ questao1: 'resposta1', questao2: 'resposta2' }],
                         user_id: respondent.id, form_id: form.id },
               headers: { 'Content-Type': 'application/json' }, as: :json
        end.to change(FormAnswer, :count).by(1)
      end

      it 'renderiza resposta JSON de sucesso ao criar uma nova resposta' do
        creator = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: creator.id })
        respondent = User.create!({ email: 'pri@email.com', password: '123456' })
        post form_answers_url,
             params: { answers: [{ questao1: 'resposta1', questao2: 'resposta2' }],
                       user_id: respondent.id, form_id: form.id },
             headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'com parametros invalidos' do
      it 'nao cria uma nova resposta' do
        creator = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: creator.id })
        respondent = User.create!({ email: 'pri@email.com', password: '123456' })
        expect do
          post form_answers_url,
               params: { answers: 1, user_id: respondent.id, form_id: form.id },
               as: :json
        end.to change(FormAnswer, :count).by(0)
      end

      it 'renderiza resposta JSON de erro ao criar uma nova resposta' do
        creator = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: creator.id })
        respondent = User.create!({ email: 'pri@email.com', password: '123456' })
        post form_answers_url,
             params: { answers: 1, user_id: respondent.id, form_id: form.id },
             headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:no_content)
        expect(response.content_type).to eq(nil)
      end
    end
  end

  describe 'PATCH /update' do # rubocop:todo Metrics/BlockLength
    context 'com parametros validos' do # rubocop:todo Metrics/BlockLength
      it 'atualiza parametros da resposta' do
        creator = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: creator.id })
        respondent = User.create!({ email: 'pri@email.com', password: '123456' })
        form_answer = FormAnswer.create!({ answers: [{ questao1: 'resposta1', questao2: 'resposta2' }],
                                           user_id: respondent.id, form_id: form.id })
        patch form_answer_url(form_answer),
              params: { answers: [{ questao1: 'resposta1', questao2: 'resposta2',
                                    questao3: 'resposta3' }], user_id: respondent.id, form_id: form.id },
              headers: { 'Content-Type': 'application/json' }, as: :json
        form_answer.reload
      end

      it 'renderiza resposta de sucesso ao atualizar parametros da resposta' do
        creator = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: creator.id })
        respondent = User.create!({ email: 'pri@email.com', password: '123456' })
        form_answer = FormAnswer.create!({ answers: [{ questao1: 'resposta1', questao2: 'resposta2' }],
                                           user_id: respondent.id, form_id: form.id })
        patch form_answer_url(form_answer),
              params: { answers: [{ questao1: 'resposta1', questao2: 'resposta2',
                                    questao3: 'resposta3' }], user_id: respondent.id, form_id: form.id },
              headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'com parametros invalidos' do
      it 'renderiza resposta JSON de erro ao atualizar parametros invalidos' do
        creator = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                              user_id: creator.id })
        respondent = User.create!({ email: 'pri@email.com', password: '123456' })
        form_answer = FormAnswer.create!({ answers: [{ questao1: 'resposta1', questao2: 'resposta2' }],
                                           user_id: respondent.id, form_id: form.id })
        patch form_answer_url(form_answer),
              params: { answers: 1, user_id: respondent.id, form_id: form.id },
              headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:no_content)
        expect(response.content_type).to eq(nil)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deleta resposta ao formulario' do
      creator = User.create!({ email: 'pri@gmail.com', password: '123456' })
      form = Form.create!({ question: [{ 'pergunta' => 'pergunta', 'type' => 'a' }],
                            user_id: creator.id })
      respondent = User.create!({ email: 'pri@email.com', password: '123456' })
      form_answer = FormAnswer.create!({ answers: [{ questao1: 'resposta1', questao2: 'resposta2' }],
                                         user_id: respondent.id, form_id: form.id })
      expect do
        delete form_answer_url(form_answer), headers: { 'Content-Type': 'application/json' }, as: :json
      end.to change(FormAnswer, :count).by(-1)
    end
  end
end
