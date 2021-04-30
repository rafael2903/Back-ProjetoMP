class FormAnswersController < ApplicationController
  before_action :set_form_answer, only: [:show, :update, :destroy]

  # GET /form_answers
  def index
    @form_answers = FormAnswer.all
    @form_answers.map do |form|
      my_xml = form.answers
      type = my_xml.kind_of? String
      if type === false
        form.answers = Hash.from_xml(my_xml).to_json
      end
    end
    render json: @form_answers
  end

  # GET /form_answers/1
  def show
    my_xml = @form_answer.answers
    type = my_xml.kind_of? String
    if type === false
      form_answer.answers = Hash.from_xml(my_xml).to_json
    end
    render json: @form_answer
  end

  # POST /form_answers
  def create
    my_json = params[:answers]
    type = my_json.kind_of? Array
    if type === true
      my_json2 = my_json.to_json
      my_xml = JSON.parse(my_json2).to_xml
      @form_answer = FormAnswer.new({answers: my_xml, user_id:
      params[:user_id], form_id: params[:form_id]})
      if @form_answer.save
        render json: @form_answer, status: :created, location: @form_answer
      else
        render json: @form_answer.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /form_answers/1
  def update
    my_json = params[:answers]
    type = my_json.kind_of? Array
    if type === true
      my_json2 = my_json.to_json
      my_xml = JSON.parse(my_json2).to_xml
      if @form_answer.update({answers: my_xml, user_id:
      params[:user_id], form_id: params[:form_id]})
        render json: @form_answer
      else
        render json: @form_answer.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /form_answers/1
  def destroy
    @form_answer.destroy
  end

  private
    def set_form_answer
      @form_answer = FormAnswer.find(params[:id])
    end

    def form_answer_params
      params.require(:form_answer).permit(:answers, :form_id, :user_id)
    end
end
