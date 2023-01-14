# frozen_string_literal: true

class Api::V1::IngredientsController < Api::AppController
  # authorize_resource
  # load_and_authorize_resource
  before_action :set_current_user_from_jwt
  before_action :set_ingredient, only: %i[destroy update edit show]
  # before_action :load_user, only: %i[index]

  before_action :authenticate_user!
  def index
    @ingredients = Ingredient.all
    render json: @ingredients, status: :ok
  end

  def show
    render json: @ingredient, status: :ok
  end

  def create
    ingredient = Ingredient.new(ingredient_params)
    if ingredient.save
      render json: ingredient, status: :created
    else
      render json: ingredient.errors, status: :unprocessable_entity
    end
  end

  def update
    if @ingredient.update(ingredient_params)
      render json: @ingredient, status: :ok
    else
      render json: @ingredient.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # bug can not destroy ingredient
    #@ingredient.delete_all
    # render json: { success: true }
  end

  def load_user
    Rails.logger.debug '88888888888888888888888888888888888888888'
    # p @current_user
    # return nill if request.headers['auth-token'].blank?
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(
      :name,
      :amount
    )
  end

  def set_ingredient
    @ingredient = Ingredient.find_by(id: params[:id])
  end
end
