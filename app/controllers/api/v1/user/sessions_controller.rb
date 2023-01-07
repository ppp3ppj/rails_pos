class Api::V1::User::SessionsController < Api::V1::User::AppController

  def sign_up
    user = User.new(user_params)
    if user.save
      render json: {success: true}, status: :created
    else 
      render json: {success: false, errors: user.errors.as_json},
          status: :bad_request
    end
  end

  def sign_in
    # raise PPPError.new("Hello World")
    user = User.find_by_email(params[:user][:email])
    raise PPPError.new("Invalid email") if user.blank?
    if user.valid_password?(params[:user][:password])
      render json: { success: true, user: user.as_json_with_jwt }
    else
      raise PPPAuthenticationError.new("Invalid email or password")
    end
  end

  def sign_out
    current_user.generate_auth_token(true)
    current_user.save
    render json: { success: true }
  end

  def me
    render json: { success: true, user: current_user.as_profile_json }
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
