class RemoveAddressLine2FromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :address_line_2
  end
end
