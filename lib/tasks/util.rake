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

    User.all.each do | ele |

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

end
