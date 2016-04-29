class RemovePartnerCodeFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :partner_code
  end
end
