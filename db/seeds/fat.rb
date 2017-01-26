# fat.rb
# This file may be used to for seeding data required by the food action tracker

MealType.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!('meal_types')

MealType.names.each do |name|
  MealType.create(caloric_budget: 500, name: name[0])
end

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

