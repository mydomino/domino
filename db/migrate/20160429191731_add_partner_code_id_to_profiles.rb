class AddPartnerCodeIdToProfiles < ActiveRecord::Migration
  def change
    add_reference :profiles, :partner_code, index: true, foreign_key: true
  end
end
