# frozen_string_literal: true

# codigo referente a estoria de usuario "EU01"
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  api :GET, '/users', 'mostra todos os usuarios do sistema'
  def index
    @users = User.all

    render json: @users
  end

  api :GET, '/users/:id', 'mostra um usuario especifico'
  param :id, :number, 'id do usuario'
  def show
    render json: @user
  end

  api :POST, '/users', 'cria um novo usuario'
  param :email, String, 'email do novo usuario'
  param :password, String, 'senha do novo usuario'
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { id: @user.id, is_admin: @user.is_admin }, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/users/:id', 'atualiza algum atributo do usuario'
  api :PUT, '/users/:id', 'atualiza algum atributo do usuario'
  param :email, String, 'novo email do usuario'
  param :password, String, 'nova senha do usuario'
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/users/:id', 'exclui usuario'
  param :id, :number, 'id do usuario'
  def destroy
    @user.destroy
  end

  api :POST, '/user/auth', 'verifica se a senha e o email sao validos, se sim: autentica o usuario'
  param :email, String, 'email do usuario'
  param :password, String, 'senha do usuario'
  def login
    @user = User.find_by(email: params[:email])
    if @user.present? && @user.password == params[:password]
      render json: { id: @user.id, is_admin: @user.is_admin }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # Codigo referente a estoria de usuario EU[16]
  api :GET, '/find_id', 'busca id do usuario pelo email'
  param :email, String, 'email do usuario'
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
