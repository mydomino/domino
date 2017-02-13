class ChangeDateFormatInMealDays < ActiveRecord::Migration
  def change
    change_column :meal_days, :date, :date
  end
end
