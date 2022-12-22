class Ingredient < ApplicationRecord
  has_many :foods_ingredients, dependent: :destroy
  has_many :foods, dependent: :destroy

  def as_ingredient_json
    json = self.as_json
    json
  end
end
