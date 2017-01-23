class DestroyLegacyUsers < ActiveRecord::Migration
  def change
    drop_table :legacy_users
  end
end
