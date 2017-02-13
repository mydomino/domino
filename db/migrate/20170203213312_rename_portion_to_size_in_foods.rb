class RenamePortionToSizeInFoods < ActiveRecord::Migration
  def change
    rename_column :foods, :portion, :size
  end
end
