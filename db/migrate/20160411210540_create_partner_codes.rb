class CreatePartnerCodes < ActiveRecord::Migration
  def change
    create_table :partner_codes do |t|
      t.string :code
      t.string :partner_name

      t.timestamps null: false
    end
  end
end
