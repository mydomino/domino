FactoryGirl.define do
  factory :lead do
    first_name "John"
    last_name  "Doe"
    email "faker"
    created_at Time.now
    start_time Time.now
  end
end