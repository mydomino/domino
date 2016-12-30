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


    # create an organization

    # perform case insensitive search
    orgs = Organization.arel_table
    organization = Organization.where(orgs[:name].matches('sunGeviTy')).first  
    #organization = Organization.find_by!("name like ?", "%Sungevity%")

    # create an org. admin user
    user = User.new({email: 'test@example.com', password: 'password', password_confirmation: 'password', role: 'org_admin'})
    user.save!


    # Add user to organization
    organization.users << user
    organization.save!

    # Show the result in reverse manner
    org = user.organization

    puts "Orginization is #{org.name} \n"

  end

  desc "Update products with Amazon price"
  task update_products_with_amazon: :environment do 
    
    Product.find_each do |product|
      product.update_amazon_price
    end

  end


  
end
