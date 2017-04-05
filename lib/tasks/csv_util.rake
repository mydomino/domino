require "#{Rails.root}/lib/helper_functions"
include HelperFunctions

namespace :csv do

	require 'csv'


  desc "Create corporate and admin users for onboarding. Usage: rake csv:create_corporate_and_admin org_name admin_first_name admin_last_name admin_org_email"
  task create_corporate_and_admin: :environment do 


    # generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    
    if ARGV.size != 7 
      puts "Error! Please provide proper parameters to your command. \n\nUsage: rake csv:create_corporate_and_admin org_name org_email org_email_domain admin_first_name admin_last_name admin_org_email\n"
      puts "Example. rake csv:create_corporate_and_admin MyDomino info@mydomino.com mydomino.com Yong Lee yong@mydomino.com\n"
      exit 1
    end

    # retrieve the org name
    org_name = ARGV[1]
    org_email = ARGV[2]
    org_email_domain = ARGV[3]

    puts "Organization name is #{org_name}. org_email is #{org_email}. org_email_domain is #{org_email_domain}\n" 

    # create an organization
    organization = Organization.find_or_create_by!(name: org_name) do |o|

      puts "Creating org #{org_name}.\n"

      o.name = org_name
      o.email = org_email
      o.email_domain = org_email_domain

    end

   
    # create org admin
    role = 'org_admin'
    for_production = false
    for_production = ENV['IS_ENVIRONMENT_FOR_TESTING'] != nil && 
      (ENV['IS_ENVIRONMENT_FOR_TESTING'].downcase != 'true' && ENV['IS_ENVIRONMENT_FOR_TESTING'].downcase != 'yes')

    u_fn = for_production ? ARGV[4] : 'test_' + ARGV[4]
    u_ln = for_production ? ARGV[5] : 'test_' + ARGV[5]
    u_email = ARGV[6]

    puts "admin_first_name is #{u_fn}. admin_last_name is #{u_ln}. admin_org_email is #{u_email}\n" 

    # email is case sensitive for the create, so convert it to lower case
    HelperFunctions::create_user(organization, u_fn, u_ln, u_email.downcase, role)

  end
	


  desc "Onboard_org_member_with_csv. Example usage: rake csv:onboard_org_member_with_csv Sungevity sample_3000.csv"
  task onboard_org_member_with_csv: :environment do 

    DATA_SAVE_FOLDER = Rails.root.join('data')

    # generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    
    if ARGV.size != 3 
      puts "Error! Please provide proper parameters to your command. \n\n"
      puts "Usage: rake csv:onboard_org_member_with_csv organization_name csv_file_name.csv. Note: please put the csv file under project's root/data folder.\n"
      puts "Example. rake csv:onboard_org_member_with_csv MyDomino sample_upload_3000.csv"
      exit 1
    end

    # retrieve the org name
    org_name = ARGV[1]

    puts "Organization name is #{org_name}.\n" 

    # find an organization
    begin
      organization = Organization.find_by!(name: org_name)
    rescue StandardError => e  
      puts "\nError! #{e.message}. Please note that the organization name is case sensitive."
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

    # check to make sure the CSV file exists
    if !File.exist?(file_name_path) 
      
      puts "\nError! #{file_name_path} does not exist. Program exit."
      exit
    end

   

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

      rescue StandardError => e  
        puts "\nException in CSV for row: #{row}! Error is: #{e.message}."
      end
    end
      

  end





  desc "Onboard_member_with_csv by group. Example usage: rake csv:onboard_member_with_csv_by_group group_fat_1 sample_3000.csv"
  task onboard_member_with_csv_by_group: :environment do 

    DATA_SAVE_FOLDER = Rails.root.join('data')

    # generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    
    if ARGV.size != 3 
      puts "Error! Please provide proper parameters to your command. \n\n"
      puts "Usage: rake csv:onboard_member_with_csv_by_group group_name csv_file_name.csv. Note: please put the csv file under project's root/data folder.\n"
      puts "Example. rake csv:onboard_member_with_csv_by_group group_fat_1 sample_upload_3000.csv"
      exit 1
    end

    # retrieve the org name
    group_name = ARGV[1]

    puts "Group name is #{group_name}.\n" 

    # find a group
    begin

      group = Group.find_or_create_by!(name: group_name) do |g|

        puts "Creating group #{group_name}.\n"
  
        g.name = group_name
        g.desc = "This is a description for " + group_name
        
      end
    rescue StandardError => e  
      puts "\nError! #{e.message}. Please note that the group name is case sensitive."
      exit
    end

    puts "Group is #{group.name}."
   

    # check to see if the data folder exist, if not create it
    full_path = File.expand_path("#{DATA_SAVE_FOLDER}")
    #puts "\nFull save path is: #{full_path}"

    if !File.exist?(full_path) 
      Dir.mkdir(full_path)
      puts "\nPath #{full_path} was created."
    end

    file_name_path = full_path + '/' +  ARGV[2] 
    puts "Data file is imported from #{file_name_path}."

    
    # check to make sure the CSV file exists
    if !File.exist?(file_name_path) 
      
      puts "\nError! #{file_name_path} does not exist. Program exit."
      exit
    end

   

    role = 'user'
    for_production = false
    for_production = ENV['IS_ENVIRONMENT_FOR_TESTING'] != nil && 
      (ENV['IS_ENVIRONMENT_FOR_TESTING'].downcase != 'true' && ENV['IS_ENVIRONMENT_FOR_TESTING'].downcase != 'yes')

    # build the out file name from the name of the input CSV file
    # the out file name is the input file name and the string 'with_signup_links'
    tmp_file_name = ARGV[2].split('.')
    out_file_name = tmp_file_name[0] + '_with_signup_links' + '.' + tmp_file_name[1]
    out_file_name_path = full_path + '/' + out_file_name

    # open a CSV file for saving the signup_link to it for each user
    out_csv = CSV.open(out_file_name_path, 'w')

    # write the headers
    out_csv << ['First_name', 'Last_name', 'Email', 'Signup_link']


    
    CSV.foreach(file_name_path, headers: true) do |row|
      begin

        puts "\n\nRow is #{row}"
        puts "Before checking env: First_name: #{row['First_name']}. Last_name: #{row['Last_name']}. Email: #{row['Email']}\n"

        next if row.size == 0

        u_fn = for_production ? row['First_name'] : 'test_' + row['First_name']
        u_ln = for_production ? row['Last_name'] : 'test_' + row['Last_name']
        u_email = row['Email'] #for_production ? u_email : u_email

        puts "After checking env: First_name: #{u_fn}. Last_name: #{u_ln}. Email: #{u_email}\n"

        # email is case sensitive for the create, so convert it to lower case
        if HelperFunctions::create_user_by_group(group, u_fn, u_ln, u_email.downcase, role)

          # send user email with on board url
          user = User.find_by!(email: u_email.downcase)

        
          # per requirement change - We are no longer sending signup link with email here
          #puts "Sending user #{user.email} an email with signup_link."
          #user.email_signup_link

          # export the member sign_up link to a csv file
          signup_link = user.get_signup_link(Rails.application.routes.url_helpers.root_url)
          puts "signup link = #{signup_link }"

          # write the headers
          out_csv << [u_fn, u_ln, u_email, signup_link]

        end

        puts "================================================================\n\n"

      rescue StandardError => e  
        puts "\nStandardError in CSV for row: #{row}! Error is: #{e.message}."
      end
    end

    
    out_csv.close if out_csv

    # email the generated CSV file to MyDomino's staff
    UserMailer.email_signup_link_csv_file(out_file_name_path).deliver_later


    #HelperFunctions::export_users_sign_up_link_to_csv(ARGV[2], #{ARGV[2]})
      

  end


  desc "Reset FAT reward points for everone"
  task reset_fat_reward_points_all_users: :environment do

    users = User.all

    # set up date range 
    # get the start day and end day of the current work week
    # start_day is the end of the work week. In our case, it is Sunday
    # end_day is the start of the work week. In our case, it is Monday
    end_date =  Time.zone.today - Time.zone.today.wday + 1
    start_date = end_date + 6
    
    
    total_start_date = Time.zone.today 
    total_end_date = Time.zone.today - 60.days

    # refresh the total reward points
    users.each do |u|
      # calculate user reward points during the period and save it to the user's member variable
      puts "reseting FAT point for #{u.email}..."
      u.get_fat_reward_points(start_date, end_date)
      u.get_total_fat_reward_points(total_start_date, total_end_date)
    end
    
  end

end
