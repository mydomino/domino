# Seed data for organizations

# Destroy Organization and Org admin user records prior to seeding
Organization.where(name: 'Test Org').destroy_all
User.where(email: 'admin@test.org').destroy_all

# Test organization
organization = Organization.create(
  name: 'test',
  email: 'test@test.org',
  email_domain: nil,
  phone: '(123) 123-1234',
  company_url: 'http://test.org',
  sign_up_code: nil,
  join_date: nil
);

#create org admin user
admin_user = User.create(
  email: 'admin@test.org',
  password: 'password',
  password_confirmation: 'password',
  role: 'org_admin',
  organization: organization
)

Profile.create(
  first_name: 'Org',
  last_name: 'Admin',
  email: admin_user.email,
  user: admin_user,
  dashboard_registered: true
)

Dashboard.create(
  user: admin_user
)

# Organization.where(name: 'Sungevity').destroy_all
# User.where(email: 'admin@sungevity.com').destroy_all
# # Sungevity
# organization = Organization.create(
#   name: 'Sungevity',
#   email: 'test@sungevity.com',
#   email_domain: 'sungevity.com',
#   phone: '(123) 123-1234',
#   company_url: 'http://sungevity.com',
#   sign_up_code: nil,
#   join_date: nil
# );

# #create org admin user
# admin_user = User.create(
#   email: 'admin@sungevity.com',
#   password: 'password',
#   password_confirmation: 'password',
#   role: 'org_admin',
#   organization: organization
# )

# Profile.create(
#   first_name: 'Org',
#   last_name: 'Admin',
#   email: admin_user.email,
#   user: admin_user,
#   dashboard_registered: true
# )

# Dashboard.create(
#   user: admin_user
# )

# Organization.where(name: 'MyDomino').destroy_all
# User.where(email: 'admin@mydomino.com').destroy_all
# # Sungevity
# organization = Organization.create(
#   name: 'MyDomino',
#   email: 'hello@mydomino.com',
#   email_domain: 'mydomino.com',
#   phone: '(123) 123-1234',
#   company_url: 'https://mydomino.com',
#   sign_up_code: nil,
#   join_date: nil
# );

# #create org admin user
# admin_user = User.create(
#   email: 'admin@mydomino.com',
#   password: 'password',
#   password_confirmation: 'password',
#   role: 'org_admin',
#   organization: organization
# )

# Profile.create(
#   first_name: 'Org',
#   last_name: 'Admin',
#   email: admin_user.email,
#   user: admin_user,
#   dashboard_registered: true
# )

# Dashboard.create(
#   user: admin_user
# )
