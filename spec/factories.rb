FactoryGirl.define do
  factory :lead do
    first_name Faker::Name.first_name
    last_name  Faker::Name.last_name
    email Faker::Internet.email
    phone Faker::PhoneNumber.phone_number
    created_at Time.now
    start_time Time.now
    ip Faker::Internet.ip_v4_address
  end
  
  factory :recommendation do
    dashboard
  end

  factory :task do
    name Faker::Lorem.words(4)
    description Faker::Lorem.paragraph
    icon "energy"
  end

  factory :concierge do
    name Faker::Name.name
    email Faker::Internet.email
    password Faker::Internet.password
  end

  factory :product do 
    url 'http://www.amazon.com/Nest-Learning-Thermostat-2nd-Generation/dp/B009GDHYPQ'
  end
  
  factory :dashboard do
    lead_name Faker::Name.name
    lead_email Faker::Internet.email
  end

  factory :contest do
    
  end

end