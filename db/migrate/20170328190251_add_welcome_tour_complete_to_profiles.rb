class AddWelcomeTourCompleteToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :welcome_tour_complete, :boolean, default: false
  end
end
