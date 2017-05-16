class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :day
      t.integer :time, default: 21
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
