class ChangeIconUrlToIconInTask < ActiveRecord::Migration
  def change
    rename_column :tasks, :icon_url, :icon
  end
end
