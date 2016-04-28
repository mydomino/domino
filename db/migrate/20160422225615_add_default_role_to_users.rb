class AddDefaultRoleToUsers < ActiveRecord::Migration
  def change
    change_column :users, :role, :string, :default => "lead"
  end
end
