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

  # Heroku scheduler, runs at 12am - 0 UTC
  #
  #
  # generate_daily_notifications
  #
  # 1st Task) query NotificationUsers
  # Grab all notifications with day = "Everyday"
  # Create a Delayed::job with the run_at field set to the same hour as `send_local_time`

  # Heroku scheduler

  desc "Send user FAT reminder notification"
  task send_user_fat_notification: :environment do 

    # get the current hour
    t = Time.zone.now.getlocal
    hour = t.hour

    duration = 10
    start_date = duration.days.ago
    end_date = t
    yesterday = 1.day.ago


    
    User.find_each do |u|

      # find user who had logged food 10 days ago and did not log yesterday
      if u.meal_days.where(["date <= ? and date >= ?", end_date, start_date]).size > 0 and 
         u.meal_days.where(date: yesterday).size == 0

         if (nt = u.notifications.where(name: Notification::FAT_NOTIFICATION).first) != nil

           if (user_noti = u.notification_users.where(notification_id: nt.id).first) != nil and 
               user_noti.local_send_time == hour

             user_noti.notify_methods.each do |noti_method|

                if noti_method.name =~ "/^email/i"
                  
                  u.email_notification(nt)
                  puts "Sent user #{u.email} email_fat_notification ... \n"

                end
             end
           end
         end
      end
    end
  end

end
