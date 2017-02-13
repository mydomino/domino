class AddMealCarbonFootprintToUsers < ActiveRecord::Migration
  def change
    add_column :users, :meal_carbon_footprint, :float, :default => 0.0
  end
end
