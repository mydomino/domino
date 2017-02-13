class CreateMealDays < ActiveRecord::Migration
  def change
    create_table :meal_days do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :date
      t.float :carbon_footprint
    end
  end
end
