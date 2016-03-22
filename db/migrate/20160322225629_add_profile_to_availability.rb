class AddProfileToAvailability < ActiveRecord::Migration
  def change
    add_column :availabilities, :profile_id, :integer
    add_foreign_key :availabilities, :profiles
  end
end
