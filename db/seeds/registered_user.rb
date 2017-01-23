if user = User.find_by_email('foo@bar.com')
  user.destroy
end

user = User.create(email: 'foo@bar.com', password: 'password', password_confirmation: 'password')
user.dashboard = Dashboard.create(lead_name: "Foo BAR", lead_email: "foo@bar.com")
user.dashboard.products = Product.default
user.dashboard.tasks = Task.default

Profile.skip_callback(:create, :after, :save_to_zoho)
Profile.create(
  first_name: 'Foo', 
  last_name: 'Bar', 
  email: 'foo@bar.com',
  address_line_1: '123 Fake st',
  city: 'Oakland',
  state: 'CA',
  zip_code: '12345',
  avg_electrical_bill: 122,
  housing: 'own', 
  dashboard_registered: true, 
  onboard_complete: true, 
  user_id: user.id
)
Profile.set_callback(:create, :after, :save_to_zoho)
