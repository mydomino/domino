class RemoveMealsFromFoods < ActiveRecord::Migration
  def change
    #first remove foreign key
    remove_foreign_key :foods, :meal

    #Remove column
    remove_column :foods, :meal_id
  end
end
