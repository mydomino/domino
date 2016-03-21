class AddDefaultsToProfile < ActiveRecord::Migration
  def change
    change_column :profiles, :address_line_1, :string, default: nil
  end
end
