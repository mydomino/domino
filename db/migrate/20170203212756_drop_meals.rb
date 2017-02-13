class DropMeals < ActiveRecord::Migration
  def change
    # Remove foreign keys
    remove_foreign_key :meals, :meal_day
    remove_foreign_key :meals, :meal_type

    #drop table
    drop_table :meals
  end
end
