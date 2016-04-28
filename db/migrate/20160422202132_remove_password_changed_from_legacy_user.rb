class RemovePasswordChangedFromLegacyUser < ActiveRecord::Migration
  def change
    remove_column :legacy_users, :password_changed
  end
end
