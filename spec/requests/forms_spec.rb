# frozen_string_literal: true

require 'rails_helper'

# testes referente a estória de usuário [EU04]
RSpec.describe "/forms", type: :request do
  describe "GET /index" do
    it "Renderiza resposta de sucesso" do
      Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }] })
      get "/forms", headers: { 'Content-Type': 'application/json' }, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "Renderiza resposta de sucesso" do
      form = Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }] })
      get form_url(form), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "com parametros validos" do
      it "criando um novo formulario" do
        expect {
          post "/forms",
               params: { :question => [{ "pergunta" => "pergunta", "type" => "a" }] },
               headers: { 'Content-Type': 'application/json' }, as: :json
        }.to change(Form, :count).by(1)
      end

      it "renderiza resposta JSON quando cria um novo formulario" do
        post "/forms",
             params: { :question => [{ "pergunta" => "pergunta", "type" => "a" }] },
             headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "com parametros invalidos" do
      it "não cria um novo formulario" do
        expect {
          post "/forms",
               params: { :question => 1 }, as: :json
        }.to change(Form, :count).by(0)
      end

      it "renderiza resposta JSON de erro quando nao cria um novo formulario" do
        post "/forms",
             params: { :question => 1 }, headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:no_content)
        expect(response.content_type).to eq(nil)
      end
    end
  end

  describe "PATCH /update" do
    context "com parametros validos" do
      it "atualiza o atributo do formulario" do
        form = Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }] })
        patch form_url(form),
              params: { :question => [{ "title" => "pergunta", "type" => "b" }] },
              headers: { 'Content-Type': 'application/json' }, as: :json
        form.reload
      end

      it "renderiza resposta JSON de sucesso" do
        form = Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }] })
        patch form_url(form),
              params: { :question => [{ "title" => "pergunta", "type" => "b" }] },
              headers: { 'Content-Type': 'application/json' }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "com parametros invalidos" do
      it "renderiza resposta de erro JSON" do
        form = Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }] })
        patch form_url(form),
              params: { :question => 1 }, headers: { 'Content-Type': 'application/json' },
              as: :json
        expect(response).to have_http_status(:no_content)
        expect(response.content_type).to eq(nil)
      end
    end
  end

  describe "DELETE /destroy" do
    it "deleta um formulario" do
      form = Form.create!({ :question => [{ "pergunta" => "pergunta", "type" => "a" }] })
      expect {
        delete form_url(form), headers: { 'Content-Type': 'application/json' }, as: :json
      }.to change(Form, :count).by(-1)
    end
  end
end
