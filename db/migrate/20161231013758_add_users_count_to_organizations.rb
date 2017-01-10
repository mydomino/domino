class AddUsersCountToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :users_count, :integer, default: 0
  end
end
