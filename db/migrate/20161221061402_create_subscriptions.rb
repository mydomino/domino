class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.datetime :start_date
      t.datetime :expire_date
      t.integer :max_member_count
      t.references :organization, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
