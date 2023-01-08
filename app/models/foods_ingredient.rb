# frozen_string_literal: true

class FoodsIngredient < ApplicationRecord
  belongs_to :food
  belongs_to :ingredient
end
