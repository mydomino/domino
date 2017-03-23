module HelperFunctions


  # create a member for onboarding step via the script
	def self.create_user(organization, first_name, last_name, u_email, role)


    success = create_user_profile_dashboard(first_name, last_name, u_email, role)

    if success

      user = User.find_by!(email: u_email)

      # Add user to organization
      organization.users << user
  
      puts "Saving info for org #{organization.name}....\n"
      organization.save!

    end

    puts "================================================================\n\n"

    return success

  end


  def self.create_user_by_group(group, first_name, last_name, u_email, role)


    success = create_user_profile_dashboard(first_name, last_name, u_email, role)

    if success

      user = User.find_by!(email: u_email)

      # Add group and user to group_user

      group_user = GroupUser.create!(user: user, group: group, datetime_sign_in: Time.zone.now)
  
      puts "Saving info for group_user #{group.name} #{user.email}....\n"
      group_user.save!

    end

    puts "================================================================\n\n"

    return success

  end



  def create_user_profile_dashboard(first_name, last_name, u_email, role)

    actions_complete = false

    ActiveRecord::Base.transaction do

      u_fn = first_name
      u_ln = last_name
  
  
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
  
  
      # user will have to specifically go to the website to register
      # himself/herself in order for the register process to be totally
      # completed 
      profile.update(dashboard_registered: false)
  
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
  
     
  
      # refer to registration_controller#after_sign_up_path_for
      # registered_user.rb
  
      # update Zoho
      puts "Sending profile data to Zoho for #{u_email}"
      profile.save_to_zoho

      # all actions were completed sucessfully. Let's set the flag to indicate that
      actions_complete = true
   
    end

    return actions_complete

  end

  def self.monday_of_current_week
    time_zone_name = Time.zone.name
    time_now = Time.now.in_time_zone(time_zone_name)
    @today = Date.new(time_now.year, time_now.month, time_now.day)

    # Date object: Monday of current week
    @today - @today.cwday + 1
  end


end