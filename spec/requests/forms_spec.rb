# frozen_string_literal: true

require 'rails_helper'

# testes referente a estória de usuário [EU04]
RSpec.describe "/forms", type: :request do
  describe "GET /index" do
    it "renderiza resposta de sucesso" do
      user = User.create!({ :email => "pri@gmail.com", :password => "123456" })
      Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }],
      :user_id => user.id })
      get "/forms", headers: { 'Content-Type': 'application/json' }, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "Renderiza resposta de sucesso" do
      user = User.create!({ :email => "pri@gmail.com", :password => "123456" })
      form = Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }],
      :user_id => user.id })
      get form_url(form), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "com parametros validos" do
      it "criando um novo formulario" do
        user = User.create!({ :email => "pri@gmail.com", :password => "123456" })
        expect {
          post "/forms",
               params: { :question => [{ "pergunta" => "pergunta", "type" => "a" }],
               :user_id => user.id },
               headers: { 'Content-Type': 'application/json' }, as: :json
        }.to change(Form, :count).by(1)
      end

      it "renderiza resposta JSON quando cria um novo formulario" do
        user = User.create!({ :email => "pri@gmail.com", :password => "123456" })
        post "/forms",
             params: { :question => [{ "pergunta" => "pergunta", "type" => "a" }],
             :user_id => user.id },
             headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "com parametros invalidos" do
      it "não cria um novo formulario" do
        expect {
          post "/forms",
               params: { :question => 1, :user_id => 1 }, as: :json
        }.to change(Form, :count).by(0)
      end

      it "renderiza resposta JSON de erro quando nao cria um novo formulario" do
        post "/forms",
             params: { :question => 1, :user_id => 1 },
             headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:no_content)
        expect(response.content_type).to eq(nil)
      end
    end
  end

  describe "PATCH /update" do
    context "com parametros validos" do
      it "atualiza o atributo do formulario" do
        user = User.create!({ :email => "pri@gmail.com", :password => "123456" })
        form = Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }],
        :user_id => user.id })
        patch form_url(form),
              params: { :question => [{ "title" => "pergunta", "type" => "b" }],
              :user_id => user.id },
              headers: { 'Content-Type': 'application/json' }, as: :json
        form.reload
      end

      it "renderiza resposta JSON de sucesso" do
        user = User.create!({ :email => "pri@gmail.com", :password => "123456" })
        form = Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }],
        :user_id => user.id })
        patch form_url(form),
              params: { :question => [{ "title" => "pergunta", "type" => "b" }],
              :user_id => user.id },
              headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "com parametros invalidos" do
      it "renderiza resposta de erro JSON" do
        user = User.create!({ :email => "pri@gmail.com", :password => "123456" })
        form = Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }],
        :user_id => user.id })
        patch form_url(form),
              params: { :question => 1, :user_id => user.id }, headers: { 'Content-Type': 'application/json' },
              as: :json
        expect(response).to have_http_status(:no_content)
        expect(response.content_type).to eq(nil)
      end
    end
  end

  describe "DELETE /destroy" do
    it "deleta um formulario" do
      user = User.create!({ :email => "pri@gmail.com", :password => "123456" })
      form = Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }],
      :user_id => user.id })
      expect {
        delete form_url(form), headers: { 'Content-Type': 'application/json' }, as: :json
      }.to change(Form, :count).by(-1)
    end
  end
end
