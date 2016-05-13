class DropUnusedTables < ActiveRecord::Migration
  def change
    drop_table :contests
    drop_table :get_starteds
    drop_table :concierges
  end
end
