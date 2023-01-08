# frozen_string_literal: true

class Api::AppController < ApplicationController
  # rescue_from PPPError, with: :handle_400
  # rescue_from PPPAuthenticationError, with: :handle_401

  # rescue_from JWT::VerificationError, with: :handle_401
  # rescue_from JWT::ExpiredSignature, with: :handle_401
  # rescue_from JWT::DecodeError, with: :handle_401
  rescue_from PPPAuthenticationError, with: :rescue_unauthorized
  rescue_from JWT::DecodeError, with: :rescue_unauthorized
  rescue_from JWT::ExpiredSignature, with: :rescue_unauthorized
  rescue_from JWT::ImmatureSignature, with: :rescue_unauthorized
  rescue_from JWT::InvalidIssuerError, with: :rescue_unauthorized
  rescue_from JWT::VerificationError, with: :rescue_unauthorized
  rescue_from ActiveRecord::RecordInvalid, with: :rescue_record_invalid

  def handle_400(exception)
    render json: { success: false, error: exception.message }, status: :bad_request and return
  end

  def handle_401(exception)
    render json: { success: false, error: exception.message }, status: :unauthorized and return
  end

  def set_current_user_from_jwt
    auth_header = request.headers['Authorization']
    raise PPPAuthenticationError, 'require user to sign in' if auth_header.blank?

    bearer = auth_header.split.first
    raise PPPAuthenticationError, 'Bad format' if bearer != 'Bearer'

    jwt = auth_header.split.last
    raise PPPAuthenticationError, 'Bad format' if jwt.blank?

    key = Rails.application.credentials.secret_key_base 
    decoded = JWT.decode(jwt, key, 'HS256')
    payload = decoded.first
    raise PPPAuthenticationError, 'Bad token' if payload.blank? || payload['auth_token'].blank?

    @current_user = User.find_by(auth_token: payload['auth_token'])
    raise PPPAuthenticationError, 'Bad token' if @current_user.blank?
  end

  def signed_in?
    Rails.logger.debug '******************************'
    Rails.logger.debug @current_user
    @current_user.present?
  end

  def authenticate_user!(_options = ())
    render_unauthorized unless signed_in?
  end

  def render_unauthorized
    error = { errors: { 'not authenticated': ['require user to sign in'] } }
    render_error(error, :unauthorized)
  end

  def render_error(error, status)
    render json: error, status:
  end

  private 

  def rescue_unauthorized(err) 
    render json: { success: false, error: err }, status: :unauthorized 
  end

  def rescue_record_invalid(err)
    render json: { success: false, error: err }, status: :bad_request
    # render json: { success: false, error: err.record.errors.as_json }, status: :bad_request
  end
end
