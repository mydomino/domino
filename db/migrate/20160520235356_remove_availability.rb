class RemoveAvailability < ActiveRecord::Migration
  def change
    remove_foreign_key :availabilities, :profile
    drop_table :availabilities
  end
end
