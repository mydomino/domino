class CreateOfferings < ActiveRecord::Migration
  def change
    create_table :offerings do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
