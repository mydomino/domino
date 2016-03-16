class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone
      t.string :housing
      t.integer :avg_electrical_bill
      t.references :availability, index: true, foreign_key: true
      t.string :comments
      t.string :partner_code
      t.boolean :onboard_complete
      t.integer :onboard_step

      t.timestamps null: false
    end
  end
end
