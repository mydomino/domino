class CreateLegacyUsers < ActiveRecord::Migration
  def change
    create_table :legacy_users do |t|
      t.string :email
      t.boolean :password_changed

      t.timestamps null: false
    end
  end
end
