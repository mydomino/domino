class ChangeProfileTimeZoneDefault2 < ActiveRecord::Migration
  def change
  	change_column :profiles, :time_zone, :string, default: "Pacific Time (US & Canada)"
  end
end
