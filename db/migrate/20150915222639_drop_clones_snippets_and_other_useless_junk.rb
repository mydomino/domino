class DropClonesSnippetsAndOtherUselessJunk < ActiveRecord::Migration
  def change
    drop_table :clones
    drop_table :snippets
  end
end
