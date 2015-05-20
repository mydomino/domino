class AddGeothermalHeatPumpToLocationSavings < ActiveRecord::Migration
  def change
    add_column :location_savings, :geothermal_heat_pump, :integer
  end
end
