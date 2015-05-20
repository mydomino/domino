class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :ip_address

      t.timestamps null: false
    end
  end
end
