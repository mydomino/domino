class AddDashboardRegisteredToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :dashboard_registered, :boolean, default: false
  end
end
