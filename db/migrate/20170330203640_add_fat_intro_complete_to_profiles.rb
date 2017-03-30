class AddFatIntroCompleteToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :fat_intro_complete, :boolean, default: false
  end
end
