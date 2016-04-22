class AddDashboardRegisteredToLegacyUser < ActiveRecord::Migration
  def change
    add_column :legacy_users, :dashboard_registered, :boolean, default: false
  end
end
