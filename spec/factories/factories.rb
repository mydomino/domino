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
end