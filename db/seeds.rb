# frozen_string_literal: true

admin = User.find_by(email: "admin@project.com")
user = User.find_by(email: "user@project.com")

if admin.blank?
  admin = User.create(email: "admin@project.com", password: 'password')
  admin.add_role :admin
end

if user.blank?
  admin = User.create(email: "user@project.com", password: 'password')
end
