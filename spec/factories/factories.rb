FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :user, :class => 'User' do
    email
    password '12345678'
    password_confirmation '12345678'
  end

  factory :concierge, :class => 'User' do
    email
    password '12345678'
    password_confirmation '12345678'
    role 'concierge'
  end

  factory :dashboard do
    user
  end

  factory :profile do
    first_name 'Foo'
    last_name 'Bar'
    email
    phone '(123)123-1234'
    city 'San Francisco'
    state 'CA'
    zip_code '94306'
    housing 'Own'
  end

end

