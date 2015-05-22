class AddCloneIdToSnippets < ActiveRecord::Migration
  def change
    add_column :snippets, :clone_id, :integer
    add_index :snippets, :clone_id
  end
end
