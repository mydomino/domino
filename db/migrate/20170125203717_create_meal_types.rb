class CreateMealTypes < ActiveRecord::Migration
  def change
    create_table :meal_types do |t|
      t.integer :caloric_budget
      t.string :name
    end
  end
end
