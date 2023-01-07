# frozen_string_literal: true

class Api::V1::FoodsController < Api::AppController
  authorize_resource
  # load_and_authorize_resource
  before_action :set_food, only: %i[destroy update edit show]
  before_action :load_user, only: %i[index]
  def index
    @foods = Food.all
    render json: @foods
  end

  def show
    render json: @food.as_detail_json, status: :ok
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)
    if @food.save
      render json: @food, status: :ok
    else
      render json: @food.errors, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @food.update(food_params)
      render json: @food
    else
      render json: @food.errors, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @food.destroy

    render json: { success: true }
    
  end

  def load_user
    return nill if request.headers['auth-token'].blank?
  end

  private

  def food_params
    params.require(:food).permit(
      :name,
      :price,
      :category_id,
      ingredient_ids: []
    )
  end

  def set_food
    @food = Food.find_by(id: params[:id])
  end
end
