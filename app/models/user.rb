# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  before_create :generate_auth_token

  def generate_auth_token(force = false)
    # self.auth_token = SecureRandom.uuid
    self.auth_token ||= SecureRandom.urlsafe_base64
    self.auth_token = SecureRandom.urlsafe_base64 if force
  end

  def jwt(exp = 15.days.from_now)
    # JWT.encode({auth_token: self.auth_token, exp: exp.to_i },
    # Rails.application.credentials.secret_key_base, "HS256")
    payload = { exp: exp.to_i, auth_token: self.auth_token }
    JWT.encode payload, Rails.application.credentials.secret_key_base, 'HS256' 
  end

  def admin?
    has_cached_role? :admin
  end

  def as_json_with_jwt
    json = {}
    json[:email] = email
    json[:auth_jwt] = jwt
    json
  end

  def as_profile_json
    json = {}
    json[:email] = email
    json
  end
end
