class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :size
      t.references :meal_day, index: true, foreign_key: true
      t.references :meal_type, index: true, foreign_key: true
    end
  end
end
