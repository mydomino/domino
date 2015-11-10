class AddSubscribeToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :subscribe_to_mailchimp, :boolean
  end
end
