class CreateNotificationUsers < ActiveRecord::Migration
  def change
    create_table :notification_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :notification, index: true, foreign_key: true
      t.string :day, default: 'Everyday'
      t.integer :time, default: 21

      t.timestamps null: false
    end

    # re-create the index with no unique
  	add_index(:notification_users, [:user_id, :notification_id], unique: false)

  end
end
