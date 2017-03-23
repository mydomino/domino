class RemoveGroupUserUniqueIndex < ActiveRecord::Migration
  def change

  	# remove the index with unique option which was created previously
  	remove_index(:group_users, [:user_id, :group_id])

  	# re-create the index with no unique
  	add_index(:group_users, [:user_id, :group_id])

  end
end
