# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

records = JSON.parse(File.read('public/data/savings_location.json'))
records.each do |state, value|
  value.each do |city, value|
    location = {state: state, city: city}
    value['dollar_savings'].each do |key, value|
      location[key.gsub('-','_')] = value
    end
    SavingsLocation.create(location)
  end
end