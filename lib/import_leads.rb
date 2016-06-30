require 'csv'

Profile.skip_callback(:create, :after, :save_to_zoho)
path = "#{File.expand_path(File.dirname(__FILE__))}/JoshFox_ZohoImport_05202016.csv"
puts path
leads = CSV.read(path, headers:true)
leads.each do |row|
  lead = Profile.create(
                            first_name: row["First Name"],
                            last_name: row["Last Name"],
                            email: row["Email"],
                            phone: row["Phone"],
                            address_line_1: row["Street"],
                            city: row["City"],
                            state: row["State"],
                            zip_code: row["Zip"],
                            partner_code_id: PartnerCode.find_by_partner_name("Josh Fox").id,
                            onboard_complete: true,
                            onboard_step: 5
                          )
  case row["Concierge"]
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
        "<FL val='First Name'>#{lead.first_name}</FL>"\
        "<FL val='Last Name'>#{lead.last_name}</FL>"\
        "<FL val='Email'>#{lead.email}</FL>"\
        "<FL val='Lead Source'>JoshFox</FL>"\
        "<FL val='Street'>#{lead.address_line_1}</FL>"\
        "<FL val='City'>#{lead.city}</FL>"\
        "<FL val='State'>#{lead.state}</FL>"\
        "<FL val='Zip Code'>#{lead.zip_code}</FL>"\
        "<FL val='Phone'>#{lead.phone}</FL>"\
        "<FL val='Partner Code'>#{lead.partner_code.code if lead.partner_code}</FL>"\
        "<FL val='Partner Code Name'>#{lead.partner_code.partner_name if lead.partner_code }</FL>"\
        "<FL val='Dashboard Been Registered?'>No</FL>"\
        "<FL val='Dashboard Registration URL'>mydomino.com/users/sign_up?email=#{lead.email}</FL>"\
        "<FL val='Onboard Complete'>Yes</FL>"\
        "<FL val='Description'>Auto Onboard May 20th, 2016</FL>"\
        "</row></Leads>"
  encoded_url = URI.encode(uri)
  url = URI.parse(encoded_url);
  Net::HTTP.post_form(url, {})
  sleep 1
end

Profile.set_callback(:create, :after, :save_to_zoho)