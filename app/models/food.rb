# frozen_string_literal: true

class Food < ApplicationRecord
  belongs_to :category
  include Rails.application.routes.url_helpers
  has_one_attached :image

  has_many :foods_ingredients, dependent: :destroy
  has_many :ingredients, through: :foods_ingredients, dependent: :destroy 

  def as_detail_json
    json = as_json
    # json[:ingredients] = self.ingredients
    json[:ingredients] = ingredients.map(&:as_ingredient_json)
    json
  end

  def as_api_json
    json = self.as_json
    if self.image.present?
      #json[:image_link] = self.food_url
      json[:image] = rails_blob_path(self.image)
      json[:image_100] = rails_representation_url(self.image.variant(resize_to_limit: [100, 100])) 
      # json[:image] = food_url
    end
    json
  end

  def food_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

end
