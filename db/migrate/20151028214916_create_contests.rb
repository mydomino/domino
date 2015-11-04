class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :slug
      t.string :name
      t.date :end_date

      t.timestamps null: false
    end
  end
end
