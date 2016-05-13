namespace :util do
  desc "TODO"
  task create_lu: :environment do
    LegacyUser.where(email: 'lu@mydomino.com').destroy_all
    LegacyUser.create(email: 'lu@mydomino.com')
    Dashboard.create(lead_name: 'Legacy User', lead_email: 'lu@mydomino.com', slug: 'legacy-user')
    Profile.create(first_name: 'Legacy', last_name: 'User', email: 'lu@mydomino.com')
  end
end
