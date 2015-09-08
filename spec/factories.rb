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
  
  factory :recommendation

  factory :concierge do
    name Faker::Name.name
    email Faker::Internet.email
    password Faker::Internet.password
  end

  factory :amazon_product do 
    url 'http://www.amazon.com/Nest-Learning-Thermostat-2nd-Generation/dp/B009GDHYPQ'
  end
  factory :amazon_storefront do
    lead_name Faker::Name.name
  end

end