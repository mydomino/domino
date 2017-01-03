namespace :util do
  desc "TODO"
  task create_lu: :environment do
    LegacyUser.where(email: 'lu@mydomino.com').destroy_all
    LegacyUser.create(email: 'lu@mydomino.com')
    Dashboard.create(lead_name: 'Legacy User', lead_email: 'lu@mydomino.com', slug: 'legacy-user')
    Profile.create(first_name: 'Legacy', last_name: 'User', email: 'lu@mydomino.com')
  end


  desc "reset_all_user_password"
  task reset_all_user_password: :environment do 

  	if Rails.env.production?
  	  puts "Error! This task can not be ran on production. Program exit."
  	  exit 1
  	end

    #User.all.each do | ele |
    User.find_each do | ele |

      begin

          puts "Changing password for #{ele.email}\n"

          u = User.find(ele.id)
      
          u.password='Mydom!no1234'
          u.password_confirmation='Mydom!no1234'
          u.save!  
          puts "User #{u.email} password is changed.\n"  

      rescue RecordNotFound => e1  
          puts "Error: User with id #{ele.id} is not found in database.\n"
          
      rescue StandardError  => e2
          puts "Error: #{e2}\n"
      end        

    end

  end

  desc "Sungevity onboarding manual steps"
  task sungevity: :environment do 

    org_name = 'Sungevity'

    # create an organization
    Organization.find_or_create_by(name: org_name) do |o|

      puts "Creating org #{org_name}.\n"

      o.name = org_name

    end

    # perform case insensitive search
    orgs = Organization.arel_table
    organization = Organization.where(orgs[:name].matches(org_name)).first  
    #organization = Organization.find_by!("name like ?", "%Sungevity%")


    u_email = 'test_2@sungevity.com'
    u_fn = 'John'
    u_ln = 'Alber'

    # create an org. admin user
    user = User.find_or_create_by(email: u_email) do |u|

      

      puts "Creating user #{u_email}.\n"

      u.email = u_email
      u.password = 'Invision98'
      u.password_confirmation = 'Invision98'
      u.role = 'org_admin'

    end

    #user = User.new({email: 'test@example.com', password: 'password', password_confirmation: 'password', role: 'org_admin'})
    
    # reate profile and associate it with the user
    #profile = Profile.create(first_name: u_fn, last_name: u_ln, email: u_email)
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
    #dashboard = Dashboard.create(lead_name: "#{u_fn} #{u_ln}", lead_email: u_email, slug: " test slug #{u_email}")
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
    DashboardRegisteredZohoJob.perform_later @profile


  end



  desc "reset_user_password based on role assignments"
  task reset_user_password: :environment do 

    for i in %w(test@example.com)

      begin

          user = User.find_by(email: i)

          puts "user is #{user.inspect}"

          puts "Changing password for #{user.email}\n"
          user.password='Invision98!!'
          user.password_confirmation='Invision98!!'
          
          user.save!  
          puts "user #{user.email} password is changed.\n"  
          
      rescue RecordNotFound => e1  
          puts "Error: User with email #{i} is not found in database.\n"
      rescue StandardError  => e2
          puts "Error: #{e2}\n"
      end        

    end

  end


  desc "Update products with Amazon price"
  task update_products_with_amazon: :environment do 
    
    Product.find_each do |product|
      product.update_amazon_price
    end

  end


  
end
