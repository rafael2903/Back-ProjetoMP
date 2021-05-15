# frozen_string_literal: true

# codigo referente a estoria de usuario "EU10"
class FormAnswersController < ApplicationController
  before_action :set_form_answer, only: %i[show update destroy]

  # GET /form_answers
  def index # rubocop:todo Metrics/MethodLength
    @form_answers = FormAnswer.all
    @form_answers.map do |form|
      my_xml = form.answers
      env = Rails.env.test?
      if env == true
        type = my_xml.is_a? String
        form.answers = Hash.from_xml(my_xml).to_json if type == false
      else
        form.answers = Hash.from_xml(my_xml).to_json
      end
    end
    render json: @form_answers
  end

  # GET /form_answers/1
  def show
    my_xml = @form_answer.answers
    env = Rails.env.test?
    if env == true
      type = my_xml.is_a? String
      @form_answer.answers = Hash.from_xml(my_xml).to_json if type == false
    else
      @form_answer.answers = Hash.from_xml(my_xml).to_json
    end
    render json: @form_answer
  end

  # POST /form_answers
  def create # rubocop:todo Metrics/MethodLength
    my_json = params[:answers]
    unless my_json.nil?
      my_json2 = my_json.to_json
      my_xml = JSON.parse(my_json2).to_xml
    end
    @form_answer = FormAnswer.new({ answers: my_xml, user_id:
    params[:user_id], form_id: params[:form_id] })
    if @form_answer.save
      render json: @form_answer, status: :created, location: @form_answer
    else
      render json: @form_answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /form_answers/1
  def update # rubocop:todo Metrics/MethodLength
    my_json = params[:answers]
    unless my_json.nil?
      my_json2 = my_json.to_json
      my_xml = JSON.parse(my_json2).to_xml
    end
    if @form_answer.update({ answers: my_xml, user_id:
      params[:user_id], form_id: params[:form_id] })
      render json: @form_answer
    else
      render json: @form_answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /form_answers/1
  def destroy
    @form_answer.destroy
  end

  def same_form
    @form_answer = FormAnswer.all
    @form_answer = @form_answer.where(form_id: params[:id])
    @form_answer.map do |form_answer|
      my_xml = form_answer.answers
      env = Rails.env.test?
      if env == true
        type = my_xml.is_a? String
        form_answer.answers = Hash.from_xml(my_xml).to_json if type == false
      else
        form_answer.answers = Hash.from_xml(my_xml).to_json
      end
    end
    render json: @form_answer.reverse
  end

  private

  def set_form_answer
    @form_answer = FormAnswer.find(params[:id])
  end

  def form_answer_params
    params.require(:form_answer).permit(:answers, :form_id, :user_id)
  end
end
