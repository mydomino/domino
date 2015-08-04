class AddTableForLeads < ActiveRecord::Migration
  def change
    create_table :leads do |table|
      table.string :first_name
      table.string :last_name
      table.string :email
      table.string :phone 
      table.string :address 
      table.string :city 
      table.string :state 
      table.integer :zip_code 
      table.string :ip
      table.string :source
      table.string :referer 
      table.timestamp :start_time 
      table.string :campaign 
      table.string :browser

      table.timestamps null: false

    end
  end
end
