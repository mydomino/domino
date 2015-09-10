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
  factory :amazon_product do 
    product_id 'B009GDHYPQ'
  end

end