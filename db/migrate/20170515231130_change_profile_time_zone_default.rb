class ChangeProfileTimeZoneDefault < ActiveRecord::Migration
  def change
  	change_column :profiles, :time_zone, :string, default: "(GMT-08:00) Pacific Time (US & Canada)"
  end
end
