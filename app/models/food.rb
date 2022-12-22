class Food < ApplicationRecord
  belongs_to :category

  has_many :foods_ingredients, dependent: :destroy
  has_many :ingredients, through: :foods_ingredients
end
