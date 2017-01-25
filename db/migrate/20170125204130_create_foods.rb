class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.references :food_type, index: true, foreign_key: true
      t.float :portion
      t.references :meal, index: true, foreign_key: true
    end
  end
end
