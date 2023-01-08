# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  before_validation :generate_auth_token, on: [:create]
  after_create :assign_default_role

  validates :email, presence: true

  def generate_auth_token(force = false)
    self.auth_token ||= SecureRandom.urlsafe_base64
    self.auth_token = SecureRandom.urlsafe_base64 if force
  end

  def jwt(exp = 5.days.from_now)
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

  def assign_default_role
    add_role(:default) if roles.blank?
  end
end
