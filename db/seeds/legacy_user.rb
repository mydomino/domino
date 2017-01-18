LegacyUser.where(email: 'lu@mydomino.com').destroy_all
User.where(email: 'lu@mydomino.com').destroy_all
Dashboard.where(lead_email: 'lu@mydomino.com').destroy_all
# Profile.where(email: 'lu@mydomino.com').destroy_all

Dashboard.create(lead_name: 'Legacy User', slug: 'legacy-user', lead_email: 'lu@mydomino.com')
Profile.skip_callback(:create, :after, :save_to_zoho)
Profile.create(first_name: 'Legacy', last_name: 'User', email: 'lu@mydomino.com', onboard_complete: true);
Profile.set_callback(:create, :after, :save_to_zoho)

LegacyUser.create(email: 'lu@mydomino.com')