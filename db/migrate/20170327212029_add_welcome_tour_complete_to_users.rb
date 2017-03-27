class AddWelcomeTourCompleteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :welcome_tour_complete, :boolean, default: false
  end
end
