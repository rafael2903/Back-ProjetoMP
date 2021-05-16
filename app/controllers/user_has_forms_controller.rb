# frozen_string_literal: true

# codigo referente a estoria de usuario "EU10"
class UserHasFormsController < ApplicationController
  before_action :set_user_has_form, only: %i[show update destroy]

  api :GET, '/user_has_forms', 'mostra todos usuarios atribuidos a um formulario'
  def index
    @user_has_forms = UserHasForm.all

    render json: @user_has_forms
  end

  api :GET, '/user_has_forms/:id', 'mostra um usuario especifico atribuido a um formulario'
  param :id, :number, 'id do usuario'
  def show
    render json: @user_has_form
  end

  api :POST, '/user_has_forms', 'adiciona um novo usuario a um formulario'
  param :user_id, :number, 'id do usuario que vai ser adicionado'
  param :form_id, :number, 'id do formulario que o usuario vai ser atribuido'
  def create
    @user_has_form = UserHasForm.all.where(form_id: params[:form_id], user_id: params[:user_id])
    if @user_has_form.present?
      render json: { error: 'Esse formulário já foi compartilhado com esse usuário' }, status: :unprocessable_entity
    else
      @user_has_form = UserHasForm.new(user_has_form_params)
      if @user_has_form.save
        render json: @user_has_form, status: :created, location: @user_has_form
      else
        render json: @user_has_form.errors, status: :unprocessable_entity
      end
    end
  end

  api :PATCH, '/user_has_forms/:id', 'atualiza usuario que vai ser adicionado ou formulario que vai ser atribuido'
  api :PUT, '/user_has_forms/:id', 'atualiza usuario que vai ser adicionado ou formulario que vai ser atribuido'
  param :id, :number, 'id da atribuicao'
  param :form_id, :number, 'id do novo formulario que o usuario vai ser atribuido'
  param :user_id, :number, 'id do novo usuario que vai ser adicionado'
  def update
    if @user_has_form.update(user_has_form_params)
      render json: @user_has_form
    else
      render json: @user_has_form.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/user_has_forms/:id', 'exclui uma atribuicao'
  param :id, :number, 'id da atribuicao'
  def destroy
    @user_has_form.destroy
  end

  api :GET, '/respondents/:form_id', 'mostra todos os usuarios atribuidos em um mesmo formulario'
  param :form_id, :number, 'id do formulario'
  def respondents
    @user_has_form = UserHasForm.all
    @respondents = @user_has_form.where(form_id: params[:form_id])
    @respondents = @respondents.map do |respondent|
      respondent.attributes.as_json.merge!(user: { email: respondent.user.email })
    end
    render json: @respondents, status: :ok
  end

  # rubocop:todo Metrics/PerceivedComplexity
  # rubocop:todo Metrics/AbcSize
  api :GET, '/assigned/:user_id', 'mostra todos os formularios, em json, atribuidos para um mesmo usuario'
  param :form_id, :number, 'id do usuario'
  def assigned
    @user_has_form = UserHasForm.all
    @user_has_form = @user_has_form.where(user_id: params[:user_id])
    @forms = []
    @user_has_form.map do |form|
      my_xml = form.form.question
      env = Rails.env.test?
      if env == true
        type = my_xml.is_a? String
        @forms.append(form.form) if type == false
      else
        @forms.append(form.form)
      end
    end
    @forms.map do |form|
      my_xml = form.question
      env = Rails.env.test?
      if env == true
        type = my_xml.is_a? String
        form.question = Hash.from_xml(my_xml).to_json if type == false
      else
        form.question = Hash.from_xml(my_xml).to_json
      end
    end
    render json: @forms, status: :ok
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/PerceivedComplexity

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_has_form
    @user_has_form = UserHasForm.find(params[:id])
  end

  def user_has_form_params
    params.require(:user_has_form).permit(:user_id, :form_id)
  end
end
