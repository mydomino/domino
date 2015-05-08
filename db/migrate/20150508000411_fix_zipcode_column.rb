class FixZipcodeColumn < ActiveRecord::Migration
  def self.up
    rename_column :location_savings, :zip, :zipcode
  end

  def self.down
    rename_column :location_savings, :zipcode, :zip
  end
end
