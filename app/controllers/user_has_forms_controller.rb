class UserHasFormsController < ApplicationController
  before_action :set_user_has_form, only: [:show, :update, :destroy]

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
