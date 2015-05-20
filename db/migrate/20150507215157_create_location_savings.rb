class CreateLocationSavings < ActiveRecord::Migration
  def change
    create_table :location_savings do |t|
      t.string :state
      t.string :city
      t.integer :zip
      t.integer :electric_car
      t.integer :electric_heat_pump
      t.integer :hybrid_car
      t.integer :led
      t.integer :offsite_solar
      t.integer :plug_in_hybrid
      t.integer :rooftop_solar
      t.integer :smart_thermostat

      t.timestamps null: false
    end
  end
end
