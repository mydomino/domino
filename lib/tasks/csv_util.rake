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


  desc "Create mydomino org and test users for testing."
  task mydomino: :environment do 

    org_name = 'Mydomino'

    # create an organization
    Organization.find_or_create_by(name: org_name) do |o|

      puts "Creating org #{org_name}.\n"

      o.name = org_name

    end

    # perform case insensitive search
    orgs = Organization.arel_table
    organization = Organization.where(orgs[:name].matches(org_name)).first  
    #organization = Organization.find_by!("name like ?", "%Sungevity%")

    role = 'org_admin'
    for u_email in %w(yong@mydomino.com johnp@mydomino.com marcian@mydomino.com jimmy@mydomino.com)

      create_user(organization, u_email, role)

    end

    role = ''
    for u_email in %w(test_1@mydomino.com test_2@mydomino.com test_3@mydomino.com)

      create_user(organization, u_email, role)

    end

    #User.destroy_all("email like '%@mydomino.com%'")


  end


  def create_user(organization, u_email, role)

    u_fn = Faker::Name::first_name
    u_ln = Faker::Name::last_name

    # create an org. admin user
    user = User.find_or_create_by(email: u_email) do |u|

      

      puts "Creating user #{u_email}.\n"

      u.email = u_email
      u.password = 'Invision98'
      u.password_confirmation = 'Invision98'
      u.role = role

    end

    
    # create profile and associate it with the user
    profile = Profile.find_or_create_by(email: u_email) do |p|

      puts "Creating profile #{u_email}.\n"

      p.first_name = u_fn
      p.last_name = u_ln
      p.email = u_email

    end


    profile.update(dashboard_registered: true)
    profile.save!

    user.profile = profile

    # Create a dashboard and associated it with the user
    dashboard = Dashboard.find_or_create_by(lead_email: u_email) do |d|

      puts "Creating dashboard #{u_email}.\n"

      d.lead_name = u_fn + " " + u_ln
      d.lead_email = u_email
      d.slug = " test slug #{u_email}"

    end


    user.dashboard = dashboard

    user.save!

   
    # Add user to organization
    organization.users << user
    organization.save!

    # Show the result in reverse manner
    org = user.organization

    puts "Orginization is #{org.name} \n"


    # refer to registration_controller#after_sign_up_path_for

    # update Zoho
    #DashboardRegisteredZohoJob.perform_later profile
    
  end







end
