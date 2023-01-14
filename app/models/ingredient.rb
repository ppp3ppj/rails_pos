# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :foods_ingredients, dependent: :destroy
  has_many :foods, dependent: :destroy

  def as_ingredient_json
    # as_json
    
  end
end
