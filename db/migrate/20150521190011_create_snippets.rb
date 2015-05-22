class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.string :key
      t.text :content
      t.string :ancestry

      t.index :ancestry

      t.timestamps null: false
    end
  end
end
