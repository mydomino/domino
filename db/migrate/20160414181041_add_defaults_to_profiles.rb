class AddDefaultsToProfiles < ActiveRecord::Migration
  def up
    change_column :profiles, :onboard_complete, :boolean, :default => false
    change_column :profiles, :onboard_step, :integer, :default => 1
    change_column :profiles, :avg_electrical_bill, :integer, :default => 0
  end

  def down
    change_column :profiles, :onboard_complete, :boolean, :default => nil
    change_column :profiles, :onboard_step, :integer, :default => nil
    change_column :profiles, :avg_electrical_bill, :integer, :default => nil
  end
end