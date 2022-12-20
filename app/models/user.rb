class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :generate_auth_token

  def generate_auth_token
    self.auth_token = SecureRandom.uuid
  end

  def jwt(exp=15.days.from_now)
    JWT.encode({auth_token: self.auth_token, exp: exp.to_i },
    Rails.application.credentials.secret_key_base, "HS256")
  end

  def admin?
    has_cached_role? :admin
  end

  def as_json_with_jwt
    json = {}
    json[:email] = self.email
    json[:auth_jwt] = self.jwt
    json
  end

  def as_profile_json
    json = {}
    json[:email] = self.email
    json
  end
end
