# frozen_string_literal: true

class Api::AppController < ApplicationController
  rescue_from PPPError, with: :handle_400
  rescue_from PPPAuthenticationError, with: :handle_401

  rescue_from JWT::VerificationError, with: :handle_401
  rescue_from JWT::ExpiredSignature, with: :handle_401
  rescue_from JWT::DecodeError, with: :handle_401

  before_action :process_token

  def handle_400(exception)
    render json: { success: false, error: exception.message }, status: :bad_request and return
  end

  def handle_401(exception)
    render json: { success: false, error: exception.message }, status: :unauthorized and return
  end

  def authenticate_user!(_options = {})
    render_unauthorized unless signed_in?
  end

  def render_unauthorized 
    error = { errors: { 'not auth': ['require user to sign in'] } }
    render_error(error, :unauthorized) 
  end

  def render_error(error, status)
    render json: error, status:
  end

  def current_user
    @current_user ||= super || User.find_by(id: @current_user_now.id)
  end

  def process_token
    auth_header = request.headers['auth-token']
    bearer = auth_header.split.first
    jwt = auth_header.split.last
    key = Rails.application.credentials.secret_key_base 
    decoded = JWT.decode(jwt, key, 'HS256')
    payload = decoded.first
    @current_user_now = User.find_by(auth_token: payload['auth_token'])
  end

  def signed_in?; end
end
