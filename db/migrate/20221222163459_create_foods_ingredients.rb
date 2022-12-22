class CreateFoodsIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :foods_ingredients do |t|
      t.references :food, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
