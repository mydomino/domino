class AddAverageSizeToFoodTypes < ActiveRecord::Migration
  def change
    add_column :food_types, :average_size, :float
  end
end
