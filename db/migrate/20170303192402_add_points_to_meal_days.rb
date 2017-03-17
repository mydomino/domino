class AddPointsToMealDays < ActiveRecord::Migration
  def change
    add_column :meal_days, :points, :integer
  end
end
