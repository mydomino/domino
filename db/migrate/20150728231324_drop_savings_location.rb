class DropSavingsLocation < ActiveRecord::Migration
  def change
    drop_table :savings_locations
  end
end
