require 'csv'

def assign_concierge(lead_owner)
  #assign concierge to lead
  case lead_owner
  when "Laura"
    @concierge = 'laura@mydomino.com'
  when "Amy"
    @concierge = 'amy@mydomino.com'
  else
    @concierge = 'mel@mydomino.com'
  end
end

#headers for Fresno import 11.07.2016:

# Column                    Profile Record        Zoho InsertRecord
# Concierge Lead Owner      n/a                   yes
# Concierge Lead Source     n/a                   yes
# Campaign                  yes                   yes
# First Name                yes                   yes
# Last Name                 yes                   yes
# Phone                     yes                   yes
# Email                     yes                   yes
# Street                    yes                   yes
# City                      yes                   yes
# State                     yes                   yes
# Zip Code                  yes                   yes
# Avg Electric Bill         n/a                   yes
# Own or Rent?              yes                   yes
# Referred By               n/a                   yes
# Partner Code              yes                   yes
# Partner Name              yes                   yes

Profile.skip_callback(:create, :after, :send_onboard_started_email)

puts "\nFile import name is #{ARGV.first}"

path = "#{File.expand_path(File.dirname(__FILE__))}/import_files/#{ARGV.first}"
puts "\nFile import path is: #{path}"

# catch CSV exception error
begin
  leads = CSV.read(path, headers:true)
  # puts "#{leads.headers}"
rescue Exception => e  
  puts "\nError! #{e.message}."
  exit
end

profiles = []

leads.each_with_index do |row, index|
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

  if lead.valid?
    #if valid push profile instance into profiles array
    #meta data is used for info that is not required on Profile record,
    #but is required in the Zoho Lead Record
    profiles << { profile: lead, 
                  meta_data: { 
                    concierge: assign_concierge(row['Concierge Lead Owner']),
                    avg_electric_bill: row['Avg Electric Bill'],
                    referred_by: row['Referred By']
                  }
                }
  else
    puts "Aborting import; Profile record invalid at row #{index}"
    puts "Error: #{lead.errors.full_messages}"
    exit
  end
end

#Profile records have been validated, 
#now save and create respective dashboards
#Push to zoho
puts "Profile records have passed validation."
puts "Saving Profile records. Creating Dashboards. Pushing Records to zoho...."

profiles.each do |p| 
  p[:profile].save
  Dashboard.create(lead_name: "#{p[:profile].first_name} #{p[:profile].last_name}", lead_email: p[:profile].email)

  #Zoho InsertRecord
  puts "Processing zoho record for: #{p[:profile].email}"

  uri = "https://crm.zoho.com/crm/private/xml/Leads/insertRecords?"\
        "newFormat=1"\
        "&authtoken=43a02c5e40acfc842e2e8ed75424ecdf"\
        "&scope=crmapi"\
        "&xmlData=<Leads><row no='1'>"\
        "<FL val='Lead Owner'>#{p[:meta_data][:concierge]}</FL>"\
        "<FL val='Lead Source'>Booth Event</FL>"\
        "<FL val='First Name'>#{p[:profile].first_name}</FL>"\
        "<FL val='Last Name'>#{p[:profile].last_name}</FL>"\
        "<FL val='Email'><![CDATA[#{CGI.escape(p[:profile].email)}]]></FL>"\
        "<FL val='Phone'>#{p[:profile].phone}</FL>"\
        "<FL val='Street'><![CDATA[#{CGI.escape(p[:profile].address_line_1) if !p[:profile].address_line_1.nil?}]]></FL>"\
        "<FL val='City'>#{p[:profile].city}</FL>"\
        "<FL val='State'>#{p[:profile].state}</FL>"\
        "<FL val='Zip Code'>#{p[:profile].zip_code}</FL>"\
        "<FL val='Own or Rent?'>#{p[:profile].housing}</FL>"\
        "<FL val='Avg Electric Bill'>#{p[:meta_data][:avg_electric_bill]}</FL>"\
        "<FL val='Referred By'>#{p[:meta_data][:referred_by]}</FL>"\
        "<FL val='Campaign'>Fresno Fall Home Improvement</FL>"\
        "<FL val='Partner Code'>#{p[:profile].partner_code.code}</FL>"\
        "<FL val='Partner Code Name'>#{p[:profile].partner_code.partner_name}</FL>"\
        "<FL val='Dashboard Been Registered?'>No</FL>"\
        "<FL val='Dashboard Registration URL'>mydomino.com/users/sign_up?email=#{CGI.escape(CGI.escape(p[:profile].email))}</FL>"\
        "<FL val='Onboard Complete'>Yes</FL>"\
        "<FL val='Description'>#{Time.new.strftime('Auto onboard %m/%d/%Y')}</FL>"\
        "</row></Leads>"

  encoded_uri = URI(uri)
  res = Net::HTTP.post_form(encoded_uri, {})
  sleep (1.0/2.0)
end

Profile.set_callback(:create, :after, :send_onboard_started_email)

