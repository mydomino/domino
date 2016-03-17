class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.references :profile, index: true, foreign_key: true
      t.references :offering, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
