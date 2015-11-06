class CreateGetStarteds < ActiveRecord::Migration
  def change
    create_table :get_starteds do |t|

      t.boolean :solar
      t.boolean :energy_plan
      t.string :area_code
      t.integer :average_electric_bill
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone


      t.timestamps null: false

    end
  end
end
