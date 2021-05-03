# frozen_string_literal: true

# TESTES referente a estoria de usuario "EU 04"
require 'rails_helper'

# testes referente a estória de usuário [EU04] # rubocop:todo Style/AsciiComments
RSpec.describe '/forms', type: :request do # rubocop:todo Metrics/BlockLength
  describe 'GET /index' do # rubocop:todo Metrics/BlockLength
    it 'renderiza resposta de sucesso' do # rubocop:todo Metrics/BlockLength
      user = User.create!({ email: 'pri@gmail.com', password: '123456' })
      Form.create!({
                     user_id: user.id,
                     question: { "title": 'Formulário sem título 1',
                                 "questions": [
                                   {
                                     "id": 1,
                                     "title": 'Qual é o seu nome',
                                     "type": 'text'
                                   },
                                   {
                                     "id": 2,
                                     "title": 'Você gosta de chocolate?',
                                     "type": 'radio',
                                     "options": %w[
                                       sim
                                       não
                                       talvez
                                     ]
                                   },
                                   {
                                     "id": 3,
                                     "title": 'Selecione suas frutas preferidas',
                                     "type": 'checkbox',
                                     "options": %w[
                                       Maçã
                                       Banana
                                       Laranja
                                       Melancia
                                       Mamão
                                     ]
                                   }
                                 ] }
                   })
      get '/forms', headers: { 'Content-Type': 'application/json' }, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do # rubocop:todo Metrics/BlockLength
    it 'Renderiza resposta de sucesso' do # rubocop:todo Metrics/BlockLength
      user = User.create!({ email: 'pri@gmail.com', password: '123456' })
      form = Form.create!({ user_id: user.id,
                            question: { "title": 'Formulário sem título 1',
                                        "questions": [
                                          {
                                            "id": 1,
                                            "title": 'Qual é o seu nome',
                                            "type": 'text'
                                          },
                                          {
                                            "id": 2,
                                            "title": 'Você gosta de chocolate?',
                                            "type": 'radio',
                                            "options": %w[
                                              sim
                                              não
                                              talvez
                                            ]
                                          },
                                          {
                                            "id": 3,
                                            "title": 'Selecione suas frutas preferidas',
                                            "type": 'checkbox',
                                            "options": %w[
                                              Maçã
                                              Banana
                                              Laranja
                                              Melancia
                                              Mamão
                                            ]
                                          }
                                        ] } })
      get form_url(form), as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do # rubocop:todo Metrics/BlockLength
    context 'com parametros validos' do # rubocop:todo Metrics/BlockLength
      it 'criando um novo formulario' do # rubocop:todo Metrics/BlockLength
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        expect do # rubocop:todo Metrics/BlockLength
          post '/forms',
               params: { user_id: user.id,
                         question: { "title": 'Formulário sem título 1',
                                     "questions": [
                                       {
                                         "id": 1,
                                         "title": 'Qual é o seu nome',
                                         "type": 'text'
                                       },
                                       {
                                         "id": 2,
                                         "title": 'Você gosta de chocolate?',
                                         "type": 'radio',
                                         "options": %w[
                                           sim
                                           não
                                           talvez
                                         ]
                                       },
                                       {
                                         "id": 3,
                                         "title": 'Selecione suas frutas preferidas',
                                         "type": 'checkbox',
                                         "options": %w[
                                           Maçã
                                           Banana
                                           Laranja
                                           Melancia
                                           Mamão
                                         ]
                                       }
                                     ] } },
               headers: { 'Content-Type': 'application/json' }, as: :json
        end.to change(Form, :count).by(1)
      end

      it 'renderiza resposta JSON quando cria um novo formulario' do # rubocop:todo Metrics/BlockLength
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        post '/forms',
             params: { user_id: user.id,
                       question: { "title": 'Formulário sem título 1',
                                   "questions": [
                                     {
                                       "id": 1,
                                       "title": 'Qual é o seu nome',
                                       "type": 'text'
                                     },
                                     {
                                       "id": 2,
                                       "title": 'Você gosta de chocolate?',
                                       "type": 'radio',
                                       "options": %w[
                                         sim
                                         não
                                         talvez
                                       ]
                                     },
                                     {
                                       "id": 3,
                                       "title": 'Selecione suas frutas preferidas',
                                       "type": 'checkbox',
                                       "options": %w[
                                         Maçã
                                         Banana
                                         Laranja
                                         Melancia
                                         Mamão
                                       ]
                                     }
                                   ] } },
             headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'com parametros invalidos' do
      it 'não cria um novo formulario' do
        expect do
          post '/forms',
               params: { user_id: 1 }, as: :json
        end.to change(Form, :count).by(0)
      end

      it 'renderiza resposta JSON de erro quando nao cria um novo formulario' do
        post '/forms',
             params: { user_id: 1 },
             headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PATCH /update' do # rubocop:todo Metrics/BlockLength
    context 'com parametros validos' do # rubocop:todo Metrics/BlockLength
      it 'atualiza o atributo do formulario' do # rubocop:todo Metrics/BlockLength
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ user_id: user.id,
                              question: { "title": 'Formulário sem título 1',
                                          "questions": [
                                            {
                                              "id": 1,
                                              "title": 'Qual é o seu nome',
                                              "type": 'text'
                                            },
                                            {
                                              "id": 2,
                                              "title": 'Você gosta de chocolate?',
                                              "type": 'radio',
                                              "options": %w[
                                                sim
                                                não
                                                talvez
                                              ]
                                            },
                                            {
                                              "id": 3,
                                              "title": 'Selecione suas frutas preferidas',
                                              "type": 'checkbox',
                                              "options": %w[
                                                Maçã
                                                Banana
                                                Laranja
                                                Melancia
                                                Mamão
                                              ]
                                            }
                                          ] } })
        patch form_url(form),
              params: { user_id: user.id,
                        question: { "title": 'Formulário sem título 1',
                                    "questions": [
                                      {
                                        "id": 1,
                                        "title": 'Qual é o seu nome',
                                        "type": 'text'
                                      },
                                      {
                                        "id": 2,
                                        "title": 'Você gosta de chocolate?',
                                        "type": 'radio',
                                        "options": %w[
                                          sim
                                          não
                                          talvez
                                        ]
                                      },
                                      {
                                        "id": 3,
                                        "title": 'Selecione suas frutas preferidas',
                                        "type": 'checkbox',
                                        "options": %w[
                                          Maçã
                                          Banana
                                          Laranja
                                          Melancia
                                          Mamão
                                        ]
                                      },
                                      {
                                        "id": 4,
                                        "title": 'Selecione suas frutas preferidas',
                                        "type": 'checkbox',
                                        "options": %w[
                                          Maçã
                                          Banana
                                          Laranja
                                          Melancia
                                          Mamão
                                        ]
                                      }
                                    ] } },
              headers: { 'Content-Type': 'application/json' }, as: :json
        form.reload
      end

      it 'renderiza resposta JSON de sucesso' do # rubocop:todo Metrics/BlockLength
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ user_id: user.id,
                              question: { "title": 'Formulário sem título 1',
                                          "questions": [
                                            {
                                              "id": 1,
                                              "title": 'Qual é o seu nome',
                                              "type": 'text'
                                            },
                                            {
                                              "id": 2,
                                              "title": 'Você gosta de chocolate?',
                                              "type": 'radio',
                                              "options": %w[
                                                sim
                                                não
                                                talvez
                                              ]
                                            },
                                            {
                                              "id": 3,
                                              "title": 'Selecione suas frutas preferidas',
                                              "type": 'checkbox',
                                              "options": %w[
                                                Maçã
                                                Banana
                                                Laranja
                                                Melancia
                                                Mamão
                                              ]
                                            }
                                          ] } })
        patch form_url(form),
              params: { user_id: user.id,
                        question: { "title": 'Formulário sem título 1',
                                    "questions": [
                                      {
                                        "id": 1,
                                        "title": 'Qual é o seu nome',
                                        "type": 'text'
                                      },
                                      {
                                        "id": 2,
                                        "title": 'Você gosta de chocolate?',
                                        "type": 'radio',
                                        "options": %w[
                                          sim
                                          não
                                          talvez
                                        ]
                                      },
                                      {
                                        "id": 3,
                                        "title": 'Selecione suas frutas preferidas',
                                        "type": 'checkbox',
                                        "options": %w[
                                          Maçã
                                          Banana
                                          Laranja
                                          Melancia
                                          Mamão
                                        ]
                                      },
                                      {
                                        "id": 4,
                                        "title": 'Selecione suas frutas preferidas',
                                        "type": 'checkbox',
                                        "options": %w[
                                          Maçã
                                          Banana
                                          Laranja
                                          Melancia
                                          Mamão
                                        ]
                                      }
                                    ] } },
              headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'com parametros invalidos' do # rubocop:todo Metrics/BlockLength
      it 'renderiza resposta de erro JSON' do # rubocop:todo Metrics/BlockLength
        user = User.create!({ email: 'pri@gmail.com', password: '123456' })
        form = Form.create!({ user_id: user.id,
                              question: { "title": 'Formulário sem título 1',
                                          "questions": [
                                            {
                                              "id": 1,
                                              "title": 'Qual é o seu nome',
                                              "type": 'text'
                                            },
                                            {
                                              "id": 2,
                                              "title": 'Você gosta de chocolate?',
                                              "type": 'radio',
                                              "options": %w[
                                                sim
                                                não
                                                talvez
                                              ]
                                            },
                                            {
                                              "id": 3,
                                              "title": 'Selecione suas frutas preferidas',
                                              "type": 'checkbox',
                                              "options": %w[
                                                Maçã
                                                Banana
                                                Laranja
                                                Melancia
                                                Mamão
                                              ]
                                            },
                                            {
                                              "id": 4,
                                              "title": 'Selecione suas frutas preferidas',
                                              "type": 'checkbox',
                                              "options": %w[
                                                Maçã
                                                Banana
                                                Laranja
                                                Melancia
                                                Mamão
                                              ]
                                            }
                                          ] } })
        patch form_url(form),
              params: { user_id: '1' }, headers: { 'Content-Type': 'application/json' },
              as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE /destroy' do # rubocop:todo Metrics/BlockLength
    it 'deleta um formulario' do # rubocop:todo Metrics/BlockLength
      user = User.create!({ email: 'pri@gmail.com', password: '123456' })
      form = Form.create!({ user_id: user.id,
                            question: { "title": 'Formulário sem título 1',
                                        "questions": [
                                          {
                                            "id": 1,
                                            "title": 'Qual é o seu nome',
                                            "type": 'text'
                                          },
                                          {
                                            "id": 2,
                                            "title": 'Você gosta de chocolate?',
                                            "type": 'radio',
                                            "options": %w[
                                              sim
                                              não
                                              talvez
                                            ]
                                          },
                                          {
                                            "id": 3,
                                            "title": 'Selecione suas frutas preferidas',
                                            "type": 'checkbox',
                                            "options": %w[
                                              Maçã
                                              Banana
                                              Laranja
                                              Melancia
                                              Mamão
                                            ]
                                          },
                                          {
                                            "id": 4,
                                            "title": 'Selecione suas frutas preferidas',
                                            "type": 'checkbox',
                                            "options": %w[
                                              Maçã
                                              Banana
                                              Laranja
                                              Melancia
                                              Mamão
                                            ]
                                          }
                                        ] } })
      expect do
        delete form_url(form), headers: { 'Content-Type': 'application/json' }, as: :json
      end.to change(Form, :count).by(-1)
    end
  end

  # codigo referente a estoria de usuario "EU[07]"
  describe 'CREATE FOR ME /create_for_me' do # rubocop:todo Metrics/BlockLength
    it 'renderiza todos os forms com user_id iguais' do # rubocop:todo Metrics/BlockLength
      user = User.create!({ email: 'pri@gmail.com', password: '123456' })
      Form.create!({ user_id: user.id,
                     question: { "title": 'Formulário sem título 1',
                                 "questions": [
                                   {
                                     "id": 1,
                                     "title": 'Qual é o seu nome',
                                     "type": 'text'
                                   },
                                   {
                                     "id": 2,
                                     "title": 'Você gosta de chocolate?',
                                     "type": 'radio',
                                     "options": %w[
                                       sim
                                       não
                                       talvez
                                     ]
                                   },
                                   {
                                     "id": 3,
                                     "title": 'Selecione suas frutas preferidas',
                                     "type": 'checkbox',
                                     "options": %w[
                                       Maçã
                                       Banana
                                       Laranja
                                       Melancia
                                       Mamão
                                     ]
                                   },
                                   {
                                     "id": 4,
                                     "title": 'Selecione suas frutas preferidas',
                                     "type": 'checkbox',
                                     "options": %w[
                                       Maçã
                                       Banana
                                       Laranja
                                       Melancia
                                       Mamão
                                     ]
                                   }
                                 ] } })
      Form.create!({ user_id: user.id,
                     question: { "title": 'Formulário sem título 1',
                                 "questions": [
                                   {
                                     "id": 1,
                                     "title": 'Qual é o seu nome',
                                     "type": 'text'
                                   },
                                   {
                                     "id": 2,
                                     "title": 'Você gosta de chocolate?',
                                     "type": 'radio',
                                     "options": %w[
                                       sim
                                       não
                                       talvez
                                     ]
                                   },
                                   {
                                     "id": 3,
                                     "title": 'Selecione suas frutas preferidas',
                                     "type": 'checkbox',
                                     "options": %w[
                                       Maçã
                                       Banana
                                       Laranja
                                       Melancia
                                       Mamão
                                     ]
                                   },
                                   {
                                     "id": 4,
                                     "title": 'Selecione suas frutas preferidas',
                                     "type": 'checkbox',
                                     "options": %w[
                                       Maçã
                                       Banana
                                       Laranja
                                       Melancia
                                       Mamão
                                     ]
                                   }
                                 ] } })
      get '/create_for_me/:id', as: :json
      expect(response).to be_successful
    end

    it 'renderiza JSON de sucesso ao retornar todos com form_id iguais' do # rubocop:todo Metrics/BlockLength
      user = User.create!({ email: 'pri@gmail.com', password: '123456' })
      Form.create!({ user_id: user.id,
                     question: { "title": 'Formulário sem título 1',
                                 "questions": [
                                   {
                                     "id": 1,
                                     "title": 'Qual é o seu nome',
                                     "type": 'text'
                                   },
                                   {
                                     "id": 2,
                                     "title": 'Você gosta de chocolate?',
                                     "type": 'radio',
                                     "options": %w[
                                       sim
                                       não
                                       talvez
                                     ]
                                   },
                                   {
                                     "id": 3,
                                     "title": 'Selecione suas frutas preferidas',
                                     "type": 'checkbox',
                                     "options": %w[
                                       Maçã
                                       Banana
                                       Laranja
                                       Melancia
                                       Mamão
                                     ]
                                   },
                                   {
                                     "id": 4,
                                     "title": 'Selecione suas frutas preferidas',
                                     "type": 'checkbox',
                                     "options": %w[
                                       Maçã
                                       Banana
                                       Laranja
                                       Melancia
                                       Mamão
                                     ]
                                   }
                                 ] } })
      Form.create!({ user_id: user.id,
                     question: { "title": 'Formulário sem título 1',
                                 "questions": [
                                   {
                                     "id": 1,
                                     "title": 'Qual é o seu nome',
                                     "type": 'text'
                                   },
                                   {
                                     "id": 2,
                                     "title": 'Você gosta de chocolate?',
                                     "type": 'radio',
                                     "options": %w[
                                       sim
                                       não
                                       talvez
                                     ]
                                   },
                                   {
                                     "id": 3,
                                     "title": 'Selecione suas frutas preferidas',
                                     "type": 'checkbox',
                                     "options": %w[
                                       Maçã
                                       Banana
                                       Laranja
                                       Melancia
                                       Mamão
                                     ]
                                   },
                                   {
                                     "id": 4,
                                     "title": 'Selecione suas frutas preferidas',
                                     "type": 'checkbox',
                                     "options": %w[
                                       Maçã
                                       Banana
                                       Laranja
                                       Melancia
                                       Mamão
                                     ]
                                   }
                                 ] } })
      get '/create_for_me/:id', as: :json
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(a_string_including('application/json'))
    end
  end
end
