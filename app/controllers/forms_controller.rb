# frozen_string_literal: true

# testes referente a estória de usuário [EU04]
class FormsController < ApplicationController
  before_action :set_form, only: %i[show update destroy]

  # GET /forms
  def index
    @forms = Form.all
    @forms.each do |form|
      my_xml = form.question
      type = my_xml.kind_of? String
      if type === false
        form.question = Hash.from_xml(my_xml).to_json
      end
    end
    render json: @forms
  end

  # GET /forms/1
  def show
    my_xml = @form.question
    type = my_xml.kind_of? String
    if type === true
      @form.question = Hash.from_xml(my_xml).to_json
    end
    render json: @form
  end

  # POST /forms
  def create
    my_json = params[:question]
    id = params[:user_id]
    type = my_json.kind_of? Array
    if type === true
      my_json2 = my_json.to_json
      my_xml = JSON.parse(my_json2).to_xml
      @form = Form.new({ question: my_xml, user_id: id })
      if @form.save
        render json: @form, status: :created, location: @form
      else
        render json: @form.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /forms/1
  def update
    my_json = params[:question]
    id = params[:user_id]
    type = my_json.kind_of? Array
    if type === true
      my_json2 = my_json.to_json
      my_xml = JSON.parse(my_json2).to_xml
      if @form.update(form_params)
        render json: @form
      else
        render json: @form.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /forms/1
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
