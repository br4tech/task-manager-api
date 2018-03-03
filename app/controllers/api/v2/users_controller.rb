class Api::V2::UsersController < ApplicationController
  # Verifica se existe um usuario na apolicação, caso não tiver encontrado retornado o 201
  before_action :authenticate_with_token!, only:[:update, :destroy]
  respond_to :json

  def show
    begin
      @user = User.find(params[:id])
      respond_with @user
    rescue
      head 404
    end
  end

  def create
    user = User.new(user_params)
    # byebug
    if user.save
      render json: user, status: 201
    else
      # byebug
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    # user = User.find(params[:id])
    # Agora so vai pegar o usuario da "sessao" para atualizar
    user = current_user

    if user.update(user_params)
      render json: user, status: 200
    else
      render json: {errors: user.errors}, status: 422
    end
  end

  def destroy
    # user  = User.find(params[:id])
    current_user.destroy
    head 204
  end

  private
  def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
  end


end
