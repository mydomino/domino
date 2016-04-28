User.destroy_all

User.create(email: 'marcian@mydomino.com', password: 'password', password_confirmation: 'password', role: 'concierge')
User.create(email: 'marcian@mydomino.com', password: 'password', password_confirmation: 'password', role: 'lead')
