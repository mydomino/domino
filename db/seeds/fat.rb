# fat.rb
# This file may be used to for seeding data required by the food action tracker

# BEGIN FoodType Seeds
FoodType.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!('food_types')

FoodType.categories.each do |category|
  FoodType.create(
    category: category[0],
    carbon_footprint: 50,
    icon: "#{category[0]}_icon.png",
    name: category[0].split('_').join(', ')
  )
end
# END FoodType Seeds
