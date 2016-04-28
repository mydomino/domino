class AddCampaignToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :campaign, :string
  end
end
