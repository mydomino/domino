class AddGeocodedToLead < ActiveRecord::Migration
  def change
    add_column :leads, :geocoded, :boolean
  end
end
