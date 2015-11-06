class AddLeadToGetStarted < ActiveRecord::Migration
  def change
    add_column :leads, :get_started_id, :integer
  end
end
