class AddLatitudeAndLongitudeToLead < ActiveRecord::Migration
  def change
    add_column :leads, :latitude, :float
    add_column :leads, :longitude, :float
  end
end
