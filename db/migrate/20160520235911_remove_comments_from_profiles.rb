class RemoveCommentsFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :comments
  end
end
