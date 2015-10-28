class RemoveLeadFieldsFromGetStarteds < ActiveRecord::Migration
  def change
    remove_column :get_starteds, :first_name
    remove_column :get_starteds, :last_name
    remove_column :get_starteds, :email
    remove_column :get_starteds, :phone
  end
end