class Api::V1::User::AppController < Api::AppController
  before_action :set_current_user_from_header, only: %i[me sign_out]

  def set_current_user_from_header
    auth_header = request.headers['auth-token']
    jwt = auth_header.split(" ").last rescue nil
    results = JWT.decode(jwt, Rails.application.credentials.secret_key_base, true, {algorithm: "HS256"})
    payload = results.first rescue nil
    # raise PPPError.new(payload.to_json)
    @current_user = User.find_by_auth_token(payload["auth_token"]) if payload.present?
  end

  def current_user(auth=true)
     raise PPPAuthenticationError.new("Not logged in or invalid auth token") if auth && @current_user.blank?
     @current_user
  end
end
