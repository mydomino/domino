namespace :csv do

	require 'faker'
	require 'csv'
	

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


  desc "Create mydomino org and users for testing."
  task mydomino: :environment do 

    org_name = 'Mydomino'

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
    for u_email in %W(yong@#{org_name}.com johnp@#{org_name}.com marcian@#{org_name}.com jimmy@#{org_name}.com)

      # email is case sensitive for the create, so convert it to lower case
      create_user(organization, u_email.downcase, role)

    end

    # create regular org user
    role = 'user'
    for u_email in %W(test_1@#{org_name}.com test_2@#{org_name}.com test_3@#{org_name}.com)

      # email is case sensitive for the create, so convert it to lower case
      create_user(organization, u_email.downcase, role)

    end


  end


  def create_user(organization, u_email, role)

    u_fn = Faker::Name::first_name
    u_ln = Faker::Name::last_name

    puts "Find or create user #{u_email}....\n"

    # create an org. admin user
    user = User.find_or_create_by(email: u_email) do |u|

      

      puts "Creating user #{u_email}.\n"

      u.email = u_email
      u.password = 'ILoveCleanEnergy'
      u.password_confirmation = 'ILoveCleanEnergy'
      u.role = role

    end

    puts "Find or create profile #{u_email}....\n"

    # create profile and associate it with the user
    profile = Profile.find_or_create_by(email: u_email) do |p|

      puts "Creating profile #{u_email}.\n"

      p.first_name = u_fn
      p.last_name = u_ln
      p.email = u_email

    end


    profile.update(dashboard_registered: true)

    puts "Saving info for profile #{u_email}....\n"
    profile.save!

    user.profile = profile

    puts "Find or create dashboard #{u_email}....\n"

    # Create a dashboard and associated it with the user
    dashboard = Dashboard.find_or_create_by(lead_email: u_email) do |d|

      puts "Creating dashboard #{u_email}.\n"

      d.lead_name = u_fn + " " + u_ln
      d.lead_email = u_email

      # do not need to set slug
      #d.slug = " test slug #{u_email}"

    end

    # associate product and tasks with dashboard
    dashboard.products = Product.default
    dashboard.tasks = Task.default

    puts "Saving info for dashboard #{u_email}....\n"
    dashboard.save!


    user.dashboard = dashboard


    puts "Saving info for user #{u_email}....\n"
    user.save!

   
    # Add user to organization
    organization.users << user

    puts "Saving info for org #{organization.name}....\n"
    organization.save!

    # Show the result in reverse manner
    org = user.organization

    puts "Orginization is #{org.name} \n"


    # refer to registration_controller#after_sign_up_path_for
    # registered_user.rb

    # update Zoho
    #profile.save_to_zoho

    
  end







end