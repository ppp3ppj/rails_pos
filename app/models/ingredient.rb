class Ingredient < ApplicationRecord
  has_many :foods_ingredients, dependent: :destroy
  has_many :foods, dependent: :destroy
end
