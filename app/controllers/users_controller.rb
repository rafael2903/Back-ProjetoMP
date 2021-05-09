# frozen_string_literal: true

# codigo referente a estoria de usuario "EU01"
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { id: @user.id, is_admin: @user.is_admin }, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user.present? && @user.password == params[:password]
      render json: { id: @user.id, is_admin: @user.is_admin }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def find_id
    @user = User.find_by(email: params[:email])
    if @user.present?
      render json: { id: @user.id }, status: :ok
    else
      render json: { error: 'Email não existe' }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :password, :is_admin)
  end
end
