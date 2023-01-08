# frozen_string_literal: true

admin = User.find_by(email: 'admin@project.com')
user = User.find_by(email: 'user@project.com')
categories = Category.all
ingredients = Ingredient.all

if admin.blank?
  admin = User.create(email: 'admin@project.com', password: 'password', confirmed_at: Time.now.utc)
  admin.skip_confirmation!
  admin.skip_confirmation_notification!
  admin.add_role :admin
end

if user.blank?
  user = User.new(email: 'user@project.com', password: 'password', confirmed_at: Time.now.utc)
  user.skip_confirmation!
  user.skip_confirmation_notification!
  user.save
end

if categories.empty?
  %w[
    Breakfast
    Lunch
  ].map { |category| Category.create(name: category) }
end

if ingredients.empty?
  %w[
    Pork
    Fish
    Coconut
    Salt
  ].map { |ingredient| Ingredient.create(name: ingredient) }
end
