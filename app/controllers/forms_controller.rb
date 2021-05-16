# frozen_string_literal: true

# codigo referente a estoria de usuario "EU04"
class FormsController < ApplicationController
  before_action :set_form, only: %i[show update destroy]

  api :GET, '/forms', 'mostra todos os formularios'
  def index # rubocop:todo Metrics/MethodLength
    @forms = Form.order(:updated_at)
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
    render json: @forms.reverse
  end

  api :GET, '/forms/:id', 'mostra um formulario especifico em json'
  param :id, :number, 'id do formulario'
  def show
    my_xml = @form.question
    env = Rails.env.test?
    if env == true
      type = my_xml.is_a? String
      @form.question = Hash.from_xml(my_xml).to_json if type == false
    else
      @form.question = Hash.from_xml(my_xml).to_json
    end
    render json: @form
  end

  api :POST, '/forms', 'cria um novo formulario e armazena em xml'
  param :user_id, :number, 'id do usuario criador de formulario'
  param :question, String, 'objeto json que que contem titulo e perguntas do formulario'
  def create # rubocop:todo Metrics/MethodLength
    my_json = params[:question]
    unless my_json.nil?
      my_json2 = my_json.to_json
      my_xml = JSON.parse(my_json2).to_xml
    end
    @form = Form.new({ question: my_xml, user_id: params[:user_id] })
    if @form.save
      render json: @form, status: :created, location: @form
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /forms/1
  api :PATCH, '/forms/:id', 'atualiza um formulario e armazena em xml'
  api :PUT, '/forms/:id', 'atualiza um formulario e armazena em xml'
  param :user_id, :number, 'id atualizado do usuario criador de formulario'
  param :question, String, 'objeto json que contem novo titulo e/ou novas perguntas do formulario'
  def update
    my_json = params[:question]
    unless my_json.nil?
      my_json2 = my_json.to_json
      my_xml = JSON.parse(my_json2).to_xml
    end
    if @form.update({ question: my_xml, user_id: params[:user_id] })
      render json: @form
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  # rubocop:todo Metrics/MethodLength
  # codigo referente a estoria de usuario "EU[07]"
  api :GET, '/created_by_me/:user_id', 'mostra todos os formularios, em json, criados pelo mesmo usuario'
  param :id, :number, 'id do usuario'
  def created_by_me # rubocop:todo Metrics/AbcSize
    @forms = Form.order(:updated_at)
    @forms = @forms.where(user_id: params[:user_id])
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
    render json: @forms.reverse
  end
  # rubocop:enable Metrics/MethodLength

  api :DELETE, '/forms/:id', 'exclui formulario'
  param :form_id, :number, 'id do formulario'
  def destroy
    @form.destroy
  end

  private

  def set_form
    @form = Form.find(params[:id])
  end

  def form_params
    params.require(:form).permit(:question, :id, :user_id)
  end
end
