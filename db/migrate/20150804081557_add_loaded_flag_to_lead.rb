class AddLoadedFlagToLead < ActiveRecord::Migration
  def change
    add_column :leads, :saved_to_zoho, :boolean
  end
end
