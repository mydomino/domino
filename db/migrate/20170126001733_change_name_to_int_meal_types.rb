class ChangeNameToIntMealTypes < ActiveRecord::Migration
  def change
    change_column :meal_types, :name, 'integer USING CAST(name AS integer)'
  end
end
