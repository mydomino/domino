class RenameLocationSavingToSavingsLocation < ActiveRecord::Migration
  def change
    rename_table :location_savings, :savings_locations
  end
end
