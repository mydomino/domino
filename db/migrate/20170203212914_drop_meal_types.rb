class DropMealTypes < ActiveRecord::Migration
  def change
    drop_table :meal_types
  end
end
