class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :fax
      t.string :company_url
      t.string :sign_up_code
      t.datetime :join_date

      t.timestamps null: false
    end
  end
end
