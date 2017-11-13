namespace :util do

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
      
          u.password='ILoveCleanEnergy'
          u.password_confirmation='ILoveCleanEnergy'
          u.save!  
          puts "User #{u.email} password is changed.\n"  

      rescue RecordNotFound => e1  
          puts "Error: User with id #{ele.id} is not found in database.\n"
          
      rescue StandardError  => e2
          puts "Error: #{e2}\n"
      end        

    end

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


  desc "Initialize users FAT reward point to 0"
  task init_users_fat_reward_points: :environment do 
    
    User.find_each do |u|
      u.fat_reward_points = 0
      u.save!
      puts "ID: #{u.id} points was set. Email: #{u.email}"
    end

  end


  desc "Send user FAT reminder notification"
  task send_user_fat__notification: :environment do 

    # get the current hour
    t = Time.zone.now.in_time_zone("Pacific Time (US & Canada)")
    hour = t.hour
    
    User.find_each do |u|
      u.fat_reward_points = 0
      u.save!
      puts "ID: #{u.id} points was set. Email: #{u.email}"
    end

  end



  
end
