# frozen_string_literal: true

class Food < ApplicationRecord
  belongs_to :category

  has_many :foods_ingredients, dependent: :destroy
  has_many :ingredients, through: :foods_ingredients

  def as_detail_json
    json = as_json
    # json[:ingredients] = self.ingredients
    json[:ingredients] = ingredients.map(&:as_ingredient_json)
    json
  end
end
