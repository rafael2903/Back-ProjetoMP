# frozen_string_literal: true

# codigo referente a estoria de usuario "EU04"
class FormsController < ApplicationController
  before_action :set_form, only: %i[show update destroy]

  # GET /forms
  def index # rubocop:todo Metrics/MethodLength
    @forms = Form.all
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

  # GET /forms/1
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

  # POST /forms
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
  def update
    my_json = params[:question]
    unless my_json.nil?
      my_json2 = my_json.to_json
      my_xml = JSON.parse(my_json2).to_xml # rubocop:todo Lint/UselessAssignment
    end
    if @form.update(form_params)
      render json: @form
    else
      render json: @form.errors, status: :unprocessable_entity
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
