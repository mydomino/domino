require 'csv'
#headers for JoshFox import 070702016:
#First Name,
#Last Name,
# Email Address,
# Phone Number,
# Concierge Lead Source,
# Concierge Lead Status,
# City,
# State,
# Concierge Lead Owner

Profile.skip_callback(:create, :after, :save_to_zoho)
path = "#{File.expand_path(File.dirname(__FILE__))}/JoshFox_ZohoImport_07072016.csv"
puts path
leads = CSV.read(path, headers:true)
leads.each do |row|
  lead = Profile.create(
                            first_name: row["First Name"],
                            last_name: row["Last Name"],
                            email: row["Email Address"],
                            phone: row["Phone Number"],
                            city: row["City"],
                            state: row["State"],
                            partner_code_id: PartnerCode.find_by_partner_name("Josh Fox").id,
                            onboard_complete: true
                          )

  case row["Concierge Lead Owner"]
  when "Laura Osburn"
    @concierge = 'laura@mydomino.com'
  when "Michaela Nye"
    @concierge = 'michaela@mydomino.com'
  else
    @concierge = 'mel@mydomino.com'
  end

  p "processing zoho record for: #{row['Email']}"

  uri = "https://crm.zoho.com/crm/private/xml/Leads/insertRecords?"\
        "newFormat=1"\
        "&authtoken=43a02c5e40acfc842e2e8ed75424ecdf"\
        "&scope=crmapi"\
        "&xmlData=<Leads><row no='1'>"\
        "<FL val='Lead Owner'>#{@concierge}</FL>"\
        "<FL val='First Name'>#{row['First Name']}</FL>"\
        "<FL val='Last Name'>#{row['Last Name']}</FL>"\
        "<FL val='Email'>#{row['Email Address']}</FL>"\
        "<FL val='Phone'>#{row['Phone Number']}</FL>"\
        "<FL val='Lead Source'>JoshFox</FL>"\
        "<FL val='Street'>#{row['Street']}</FL>"\
        "<FL val='City'>#{row['City']}</FL>"\
        "<FL val='State'>#{row['State']}</FL>"\
        "<FL val='Partner Code'>JOSHFOX</FL>"\
        "<FL val='Partner Code Name'>Josh Fox</FL>"\
        "<FL val='Dashboard Been Registered?'>No</FL>"\
        "<FL val='Dashboard Registration URL'>mydomino.com/users/sign_up?email=#{row['Email Address']}</FL>"\
        "<FL val='Onboard Complete'>Yes</FL>"\
        "<FL val='Description'>Auto Onboard July 7, 2016</FL>"\
        "</row></Leads>"
  encoded_url = URI.encode(uri)
  url = URI.parse(encoded_url);
  Net::HTTP.post_form(url, {})
  sleep (1.0/2.0)
end

Profile.set_callback(:create, :after, :save_to_zoho)