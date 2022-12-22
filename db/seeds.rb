# frozen_string_literal: true

admin = User.find_by(email: "admin@project.com")
user = User.find_by(email: "user@project.com")
categories = Category.all
ingredients = Ingredient.all

if admin.blank?
  admin = User.create(email: "admin@project.com", password: 'password')
  admin.add_role :admin
end

if user.blank?
  admin = User.create(email: "user@project.com", password: 'password')
end

if categories.size.zero?
  [
    "Breakfast",
    "Lunch"
  ].map { |category| Category.create(name: category) }
end

if ingredients.size.zero?
  [
    "Pork",
    "Fish",
    "Coconut",
    "Salt"
  ].map { |ingredient| Ingredient.create(name: ingredient) }
end
