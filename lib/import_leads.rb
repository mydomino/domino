require 'csv'

# Profile.skip_callback(:create, :after, :save_to_zoho)
path = "#{File.expand_path(File.dirname(__FILE__))}/JoshFox_ZohoImport_06232016.csv"
# puts path
leads = CSV.read(path, headers:true)
leads.each do |row|
#   lead = Profile.create(
#                             first_name: row["First Name"],
#                             last_name: row["Last Name"],
#                             email: row["Email"],
#                             address_line_1: row["Street"],
#                             city: row["City"],
#                             state: row["State"],
#                             zip_code: row["Zip Code"],
#                             phone: row["Phone"],
#                             partner_code_id: PartnerCode.find_by_partner_name("Josh Fox").id,
#                             onboard_complete: true
#                           )
  case row["Concierge Lead Owner"]
  when "Laura Osburn"
    @concierge = 'laura@mydomino.com'
  when "Michaela Nye"
    @concierge = 'michaela@mydomino.com'
  else
    @concierge = 'mel@mydomino.com'
  end

  p "processing zoho record for: #{lead.email}"

  uri = "https://crm.zoho.com/crm/private/xml/Leads/insertRecords?"\
        "newFormat=1"\
        "&authtoken=43a02c5e40acfc842e2e8ed75424ecdf"\
        "&scope=crmapi"\
        "&xmlData=<Leads><row no='1'>"\
        "<FL val='Lead Owner'>#{@concierge}</FL>"\
        "<FL val='First Name'>#{row['First Name']}</FL>"\
        "<FL val='Last Name'>#{row['Last Name']}</FL>"\
        "<FL val='Email'>#{row['Email']}</FL>"\
        "FL val='Phone'>#{row['Phone']}</FL>"\
        "<FL val='Lead Source'>Josh Fox</FL>"\
        "<FL val='Street'>#{row['street']}</FL>"\
        "<FL val='City'>#{row['City']}</FL>"\
        "<FL val='State'>#{row['State']}</FL>"\
        "<FL val='Zip Code'>#{row['Zip Code']}</FL>"\
        "<FL val='Partner Code'>JOSHFOX</FL>"\
        "<FL val='Partner Code Name'>Josh Fox</FL>"\
        "<FL val='Dashboard Been Registered?'>No</FL>"\
        "<FL val='Dashboard Registration URL'>mydomino.com/users/sign_up?email=#{row['Email']}</FL>"\
        "<FL val='Onboard Complete'>Yes</FL>"\
        "<FL val='Description'>Auto Onboard June 24, 2016</FL>"\
        "</row></Leads>"
  encoded_url = URI.encode(uri)
  url = URI.parse(encoded_url);
  Net::HTTP.post_form(url, {})
  sleep 1
end

# Profile.set_callback(:create, :after, :save_to_zoho)