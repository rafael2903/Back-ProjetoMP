# frozen_string_literal: true

require 'csv'

# codigo referente a estoria de usuario "EU10"
class FormAnswersController < ApplicationController # rubocop:todo Metrics/ClassLength
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
    @form_answers = FormAnswer.all.where(form_id: params[:form_id])
    @form_answers.map do |form_answer|
      form_answer.answers = xml_to_json(form_answer)
    end
    form_answers = @form_answers.map do |form_answer|
      form_answer.attributes.as_json.merge!({ user_email: form_answer.user&.email })
    end
    render json: form_answers
  end

  def xml_to_json(form_answer)
    my_xml = form_answer.answers
    env = Rails.env.test?
    if env == true && (!my_xml.is_a? String)
      Hash.from_xml(my_xml).to_json
    elsif env == false
      Hash.from_xml(my_xml).to_json
    end
  end

  # rubocop:todo Metrics/PerceivedComplexity
  # rubocop:todo Metrics/MethodLength
  # rubocop:todo Metrics/AbcSize
  def download_answers # rubocop:todo Metrics/CyclomaticComplexity
    @form_answers = FormAnswer.all
    @form_answers = @form_answers.where(form_id: params[:form_id])
    CSV.open('answers.csv', 'w') do |csv|
      if @form_answers.present?
        headers = Hash.from_xml(@form_answers.first.answers)['hash']['questions'].map { |question| question['title'] }
        csv.add_row(headers)
        @form_answers.each do |answer|
          answers = Hash.from_xml(answer.answers)['hash']['questions'].map do |question|
            if question['type'] == 'text'
              question['value']
            else
              @selected_options = question['options'].select { |option| option['checked'] }
              @selected_options = @selected_options.map { |option| option['value'] }
              @selected_options.join(',')
            end
          end
          csv.add_row(answers)
        end
      end
    end
    send_file 'answers.csv', type: 'text/csv'
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  private

  def set_form_answer
    @form_answer = FormAnswer.find(params[:id])
  end

  def form_answer_params
    params.require(:form_answer).permit(:answers, :form_id, :user_id)
  end
end
