puts "this is just a test"
leads = Lead.all #may be more leads than dashoards
dbs = Dashboard.all
#normalize all lead and associated dashboard email addresses
leads.each do |lead|
  email = lead.email
  lead.update(email: email.gsub(/\s+/, "").downcase)
end

dbs.each do |db|
  email = db.lead_email
  db.update(lead_email: email.gsub(/\s+/, "").downcase)
end

#now emails on current dashboard and lead records are normalized

#create legacy user records 
# leads = Lead.all
# leads.each do |lead|
#   LegacyUser.create(email: lead.email)
# end

#create legacy user for existing dashboards
dbs.each do |db|
  LegacyUser.create(email: db.lead_email)
end
# create profiles for legacy users
legacy_users = LegacyUser.all
legacy_users.each do |lu|
  lead = Lead.find_by_email(lu.email)
  if lead
    Profile.create(
      first_name: lead.first_name || "",
      last_name: lead.last_name || "",
      email: lead.email,
      phone: lead.phone,
      address_line_1: lead.address,
      city: lead.city,
      state: lead.state,
      zip_code: lead.zip_code,
      ip: lead.ip,
      referer: lead.referer,
      campaign: lead.campaign,
      browser: lead.browser,
      onboard_complete: true
    );
  else
    Profile.create(
      first_name: "unknown",
      last_name: "unknown",
      email: lu.email,
      onboard_complete: true
    );
  end
end
#create concierge users
User.destroy_all
User.create(email: 'mel@mydomino.com', password: 'cleanenergy', password_confirmation: 'cleanenergy', role: 'concierge')
User.create(email: 'laura@mydomino.com', password: 'cleanenergy', password_confirmation: 'cleanenergy', role: 'concierge')
User.create(email: 'michaela@mydomino.com', password: 'cleanenergy', password_confirmation: 'cleanenergy', role: 'concierge')

#map dashboards to new concierge ids
dbs.each do |db|
  if !db.concierge_id.nil?
    if concierge = Concierge.find(db.concierge_id) 
      if concierge_user = User.find_by_email(concierge.email)
        db.update(concierge_id: concierge_user.id)
      end
    end
  else
    db.update(concierge_id: User.find_by_email('mel@mydomino.com').id)
  end
end

#test case
legacy_users.each do |legacy_user|
#lastlt send emails to all dashboards already in existence
  UserMailer.legacy_user_registration_email(legacy_user.email).deliver_later
end