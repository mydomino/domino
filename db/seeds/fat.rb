# fat.rb
# This file may be used to for seeding data required by the food action tracker

# BEGIN FoodType Seeds
# CF map
# C02 emission values in grams per KiloCalorie
cf_map = {
  "fruits": 4.6,
  "vegetables": 2.8,
  "dairy": 4.5,
  "grains": 1.3,
  "fish_poultry_pork": 3.8,
  "beef_lamb": 14.1
}.with_indifferent_access


FoodType.destroy_all

# Reset PK key to start at 1
ActiveRecord::Base.connection.reset_pk_sequence!('food_types')

FoodType.categories.each do |key, value|
  FoodType.create(
    category: key,
    carbon_footprint: cf_map[key],
    icon: "#{key}_icon.png",
    name: key.split('_').join(', ')
  )
end
# END FoodType Seeds
