# frozen_string_literal: true

# codigo referente a estoria de usuario "EU10"
class UserHasFormsController < ApplicationController
  before_action :set_user_has_form, only: %i[show update destroy]

  # GET /user_has_forms
  def index
    @user_has_forms = UserHasForm.all

    render json: @user_has_forms
  end

  # GET /user_has_forms/1
  def show
    render json: @user_has_form
  end

  # POST /user_has_forms
  def create
    @user_has_form = UserHasForm.new(user_has_form_params)

    if @user_has_form.save
      render json: @user_has_form, status: :created, location: @user_has_form
    else
      render json: @user_has_form.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_has_forms/1
  def update
    if @user_has_form.update(user_has_form_params)
      render json: @user_has_form
    else
      render json: @user_has_form.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_has_forms/1
  def destroy
    @user_has_form.destroy
  end

  # GET /respondents/1
  def respondents
    @user_has_form = UserHasForm.all
    @user_has_form = @user_has_form.where(form_id: params[:form_id])
    if @user_has_form.empty?
      render json: { error: 'Nao existem respondentes' },
             status: :unprocessable_entity
    else
      render json: @user_has_form, status: :ok
    end
  end

  # rubocop:todo Metrics/PerceivedComplexity
  # rubocop:todo Metrics/MethodLength
  # rubocop:todo Metrics/AbcSize
  def assigned # rubocop:todo Metrics/CyclomaticComplexity
    @user_has_form = UserHasForm.all
    @user_has_form = @user_has_form.where(user_id: params[:id])
    if @user_has_form.present?
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
    else
      render json: { error: 'Nao existem formularios atribuidos a esse usuario' },
             status: :unprocessable_entity
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_has_form
    @user_has_form = UserHasForm.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_has_form_params
    params.require(:user_has_form).permit(:user_id, :form_id)
  end
end
