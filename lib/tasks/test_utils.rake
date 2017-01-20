require "#{Rails.root}/lib/helper_functions"
require 'faker'

include HelperFunctions


# This file contains all test functions used for testings purposes
namespace :md_test do

	


  desc "Generate X number of fake data rows for CSV file upload. Example usage: rake csv:build_csv_file_with_fake_data 200"
  task build_csv_file_with_fake_data: :environment do 

  	DATA_SAVE_FOLDER = Rails.root.join('data')

  	# generate an empty task for each argument pass in
  	ARGV.each { |a| task a.to_sym do ; end }

  	# validate argument type - only number allow
  	if ARGV[1].nil? or ARGV[1] !~ /\A\d+\z/
  		puts "Error! Please include a number in your command. Example. rake csv:build_csv_file_with_fake_data 1000"
  		exit 1
  	end

  	# check to see if the data folder exist, if not create it
    full_path = File.expand_path("#{DATA_SAVE_FOLDER}")
    #puts "\nFull save path is: #{full_path}"

    if !File.exist?(full_path) 
      Dir.mkdir(full_path)
      puts "\nPath #{full_path} was created."
    end

    file_name_path = full_path + '/' + 'sample_upload_' + ARGV[1] + '.csv'
    puts "Data file is saved on #{file_name_path}."

  	CSV.open(file_name_path, 'w') do |csv| 

      # Add new headers
      csv << ['First_name', 'Last_name', 'Email']  
 
      # using the pass in argument
      for i in 1..ARGV[1].to_i
      	 data_row = [Faker::Name::first_name, Faker::Name::last_name, Faker::Internet.email]
      	 csv << data_row
      end
    end

  end






  desc "Create corporate and admin users for onboarding."
  task create_corporate_and_admin: :environment do 

    org_name = 'MyDomino'

    # create an organization
    organization = Organization.find_or_create_by(name: org_name) do |o|

      puts "Creating org #{org_name}.\n"

      o.name = org_name

    end

    # perform case insensitive search
    #orgs = Organization.arel_table
    #organization = Organization.where(orgs[:name].matches(org_name)).first  
    
    # create org admin
    role = 'org_admin'
    for_production = false
    for u_email in %W(yong@#{org_name}.com johnp@#{org_name}.com marcian@#{org_name}.com jimmy@#{org_name}.com)

      u_fn = for_production ? Faker::Name::first_name : 'test_' + Faker::Name::first_name
      u_ln = for_production ? Faker::Name::last_name : 'test_' + Faker::Name::last_name
      u_email = for_production ? u_email : u_email

      # email is case sensitive for the create, so convert it to lower case
      HelperFunctions::create_user(organization, u_fn, u_ln, u_email.downcase, role)

    end

    # create regular org user
    role = 'user'
    for_production = false
    for u_email in %W(test_1@#{org_name}.com test_2@#{org_name}.com test_3@#{org_name}.com)


      u_fn = for_production ? Faker::Name::first_name : 'test_' + Faker::Name::first_name
      u_ln = for_production ? Faker::Name::last_name : 'test_' + Faker::Name::last_name
      u_email = for_production ? u_email :  u_email

      # email is case sensitive for the create, so convert it to lower case
      HelperFunctions::create_user(organization, u_fn, u_ln, u_email.downcase, role)

    end


  end

end