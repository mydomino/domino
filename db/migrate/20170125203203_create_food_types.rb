class CreateFoodTypes < ActiveRecord::Migration
  def change
    create_table :food_types do |t|
      t.integer :category
      t.float :carbon_footprint
      t.string :icon
      t.string :name
    end
  end
end
