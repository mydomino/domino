class ChangeCommentsToTextOnProfiles < ActiveRecord::Migration
  def change
    change_column :profiles, :comments, :text
  end
end
