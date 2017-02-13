class AddMealDayFkToFoods < ActiveRecord::Migration
  def change
    add_foreign_key :foods, :meal_days
  end
end
