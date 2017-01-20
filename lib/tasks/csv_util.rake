require "#{Rails.root}/lib/helper_functions"
include HelperFunctions

namespace :csv do

	require 'csv'
	


  desc "Onboard_org_member_with_csv. Example usage: rake csv:onboard_org_member_with_csv Sungevity sample_3000.csv"
  task onboard_org_member_with_csv: :environment do 

    DATA_SAVE_FOLDER = Rails.root.join('data')

    # generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    
    if ARGV.size != 3 
      puts "Error! Please provide proper parameters to your command. Example. rake csv:onboard_org_member_with_csv Sungevity sample_upload_3000.csv"
      exit 1
    end

    # retrieve the org name
    org_name = ARGV[1]

    puts "Organization name is #{org_name}.\n" 

    # find an organization
    begin
      organization = Organization.find_by!(name: org_name)
    rescue Exception => e  
      puts "\nError! #{e.message}. Please note: the name is case sensitive."
      exit
    end
   

    # check to see if the data folder exist, if not create it
    full_path = File.expand_path("#{DATA_SAVE_FOLDER}")
    #puts "\nFull save path is: #{full_path}"

    if !File.exist?(full_path) 
      Dir.mkdir(full_path)
      puts "\nPath #{full_path} was created."
    end

    file_name_path = full_path + '/' +  ARGV[2] 
    puts "Data file is imported from #{file_name_path}."

   

    role = 'user'
    for_production = false
    for_production = ENV['IS_ENVIRONMENT_FOR_TESTING'] != nil && 
      (ENV['IS_ENVIRONMENT_FOR_TESTING'].downcase != 'true' && ENV['IS_ENVIRONMENT_FOR_TESTING'].downcase != 'yes')
    
    CSV.foreach(file_name_path, headers: true) do |row|
      begin

        puts "\n\nRow is #{row}"
        #puts "Before checking env: First_name: #{row['First_name']}. Last_name: #{row['Last_name']}. Email: #{row['Email']}\n"

        next if row.size == 0

        u_fn = for_production ? row['First_name'] : 'test_' + row['First_name']
        u_ln = for_production ? row['Last_name'] : 'test_' + row['Last_name']
        u_email = row['Email'] #for_production ? u_email : u_email

        puts "After checking env: First_name: #{u_fn}. Last_name: #{u_ln}. Email: #{u_email}\n"

        # email is case sensitive for the create, so convert it to lower case
        if HelperFunctions::create_user(organization, u_fn, u_ln, u_email.downcase, role)

          # send user email with on board url
          user = User.find_by!(email: u_email.downcase)

          # send user with on borad instructions and signup token
          #user.email_onboard_url(u_fn, u_ln)
          user.email_signup_link
         
        end

      rescue Exception => e  
        puts "\nException in CSV for row: #{row}! Error is: #{e.message}."
      end
    end
      

  end


end
