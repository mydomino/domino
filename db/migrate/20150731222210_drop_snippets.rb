class DropSnippets < ActiveRecord::Migration
  def change
    drop_table :snippets
  end
end
