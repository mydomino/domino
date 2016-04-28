class AddTrackingVariablesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :ip, :string
    add_column :profiles, :referer, :string
    add_column :profiles, :browser, :string
  end
end
