Offering.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!('offerings')
Offering.create(name: 'Clean Power Options')
Offering.create(name: 'Rooftop Solar (PV)')
Offering.create(name: 'Smart Thermostats')
Offering.create(name: 'LED Light Bulbs')
Offering.create(name: 'Smart Power Strips')
Offering.create(name: 'Heat Pumps')
Offering.create(name: 'Electric Vehicles')
Offering.create(name: 'EV Chargers')
Offering.create(name: 'Electric Bikes')