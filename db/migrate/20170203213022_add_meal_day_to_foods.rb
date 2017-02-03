class AddMealDayToFoods < ActiveRecord::Migration
  def change
    add_reference :foods, :meal_day, index: true
  end
end
