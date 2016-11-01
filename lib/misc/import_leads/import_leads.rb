require 'csv'
#headers for LAGreenFestival import 09192016:
# "First Name"
# "Last Name"
# "Phone"
# "Email"
# "Street"
# "City"
# "State"
# "Zip Code"
# "Avg Electric Bill"
# "Own or Rent?"
# "Referred By"
# "Concierge Lead Source"
# "Campaign"
# "Partner Code"
# "Partner Name"
# "Concierge Lead Owner"

# Profile.skip_callback(:create, :after, :save_to_zoho)
Profile.skip_callback(:create, :after, :send_onboard_started_email)

puts "\nFile import name is #{ARGV.first}"

path = "#{File.expand_path(File.dirname(__FILE__))}/import_files/#{ARGV.first}"
#path = "#{File.expand_path(File.dirname(__FILE__))}/import_files/Bakersfield_ZohoImport_10242016.csv"
puts "\nFile import path is: #{path}"

# catch CSV exception error
begin
  leads = CSV.read(path, headers:true)
rescue Exception => e  
  puts "\nError! #{e.message}."
  exit
end

leads.each do |row|

  lead = Profile.new(
          first_name: row["First Name"],
          last_name: row["Last Name"],
          email: row["Email"],
          phone: row["Phone"],
          address_line_1: row["Street"],
          city: row["City"],
          state: row["State"],
          zip_code: row["Zip Code"],
          housing: row["Own or Rent?"],  
          #omitting avg electrical bill b/c Rails uses integer, sheet is formatted with strings
          campaign: row["Campaign"],
          partner_code_id: PartnerCode.find_by_code(row['Partner Code']).id,
          onboard_complete: true,
          onboard_step: 4
        )

  # Dashboard.create(lead_name: "#{lead.first_name} #{lead.last_name}", lead_email: lead.email)


  case row["Concierge Lead Owner"]
  when "Laura"
    @concierge = 'laura@mydomino.com'
  when "Amy"
    @concierge = 'amy@mydomino.com'
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
        "<FL val='Lead Source'>#{row['Concierge Lead Source']}</FL>"\
        "<FL val='First Name'>#{row['First Name']}</FL>"\
        "<FL val='Last Name'>#{row['Last Name']}</FL>"\
        "<FL val='Email'><![CDATA[#{CGI.escape(lead.email)}]]></FL>"\
        "<FL val='Phone'>#{row['Phone']}</FL>"\
        "<FL val='Lead Source'>#{row['Concierge Lead Source']}</FL>"\
        "<FL val='Street'><![CDATA[#{CGI.escape(row['Street']) if !row['Street'].nil?}]]></FL>"\
        "<FL val='City'>#{row['City']}</FL>"\
        "<FL val='State'>#{row['State']}</FL>"\
        "<FL val='Zip Code'>#{row['Zip Code']}</FL>"\
        "<FL val='Own or Rent?'>#{row['Own or Rent?']}</FL>"\
        "<FL val='Avg Electric Bill'>#{row['Avg Electric Bill']}</FL>"\
        "<FL val='Referred By'>#{row['Referred By']}</FL>"\
        "<FL val='Campaign'>#{row['Campaign']}</FL>"\
        "<FL val='Partner Code'>#{lead.partner_code.code}</FL>"\
        "<FL val='Partner Code Name'>#{lead.partner_code.partner_name}</FL>"\
        "<FL val='Dashboard Been Registered?'>No</FL>"\
        "<FL val='Dashboard Registration URL'>mydomino.com/users/sign_up?email=#{CGI.escape(CGI.escape(lead.email))}</FL>"\
        "<FL val='Onboard Complete'>Yes</FL>"\
        "<FL val='Description'>#{Time.new.strftime('Auto onboard %m/%d/%Y')}</FL>"\
        "</row></Leads>"

  encoded_uri = URI(uri)
  res = Net::HTTP.post_form(encoded_uri, {})
  sleep (1.0/2.0)
end

Profile.set_callback(:create, :after, :send_onboard_started_email)
