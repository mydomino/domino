#concierges.rb
#

if user = User.find_by_email("concierge@mydomino.com");
  user.destroy
end

User.create(email: "concierge@mydomino.com", password: "cleanenergy", password_confirmation: "cleanenergy", role: "concierge")
