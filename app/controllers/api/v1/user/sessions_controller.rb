# frozen_string_literal: true

class Api::V1::User::SessionsController < Api::V1::User::AppController
  before_action :set_current_user_from_jwt, only: %i[me sign_out]
  def sign_up
    user = User.new(user_params)
    user.save!
    render json: { success: true, confirmation_token: user.confirmation_token }, status: :created
    # if user.save
    #   render json: { success: true }, status: :created
    # else 
    #   render json: { success: false, errors: user.errors.as_json },
    #          status: :bad_request
    # end
  end

  def sign_in
    user = User.find_by(email: params[:user][:email])
    if user.confirmed? && user.valid_password?(params[:user][:password])
      render json: { success: true, jwt: user.jwt(5.days.from_now) },
             status: :ok
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  def sign_out
    @current_user.generate_auth_token(true)
    @current_user.save
    render json: { success: true }
  end

  def me
    render json: { success: true, user: @current_user.as_json }
  end

  def confirm
    user = User.find_by(confirmation_token: params[:confirmation_token])
    render json: { success: user.confirm }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
