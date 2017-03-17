namespace :md_test do

	desc "test carbon footprint for a user"
  task test_user_cfp: :environment do

  	# generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    
    if ARGV.size != 2 
      puts "Error! Please provide proper parameters to your command. \n\nUsage: rake md_test:test_user_cfp user_email\n"
      puts "Example: rake md_test:test_user_cfp yong@mydomino.com\n"
      exit 1
    end

    user_email = ARGV[1]

    puts "\n User email is #{user_email}\n"


    begin

    	user = User.find_by!(email: user_email)
    	#user = User.find_by!(email: 'yong@mydomino.com')

    rescue ActiveRecord::RecordNotFound
    	puts "\n Error: user with email #{user_email} is not found. \nPlease run rake csv:create_corporate_and_admin to create the test user. Program exit.\n"
    	exit
    end
    


  	
  	# set up the data set in database for testing 
  	set_up(5, user)

  	# test ...

  	#set up date range
  	start_date = Time.zone.today 
  	end_date = Time.zone.today - 60.days

    @total_carbon_foodprint = 0

  	user.meal_days.where(["date <= ? and date >= ?", start_date, end_date]).each do |meal_day|

      puts "meal_day: #{meal_day.date}\n"
      meal_day.carbon_footprint = 0

      meal_day.foods.each do |food|

        
        meal_day.carbon_footprint += (food.food_type.carbon_footprint * food.size)


        puts "food.food_type.carbon_footprint = #{food.food_type.carbon_footprint}. day_carbon_foodprint = #{meal_day.carbon_footprint}."
          
      end

      # save the calculated value
      meal_day.save!

  
      puts "Carbon footprint for day: #{meal_day.date} is #{meal_day.carbon_footprint}\n"
      @total_carbon_foodprint += meal_day.carbon_footprint


    end


    puts "Total Carbon footprint for the period is #{@total_carbon_foodprint}\n"

  	# 

  end




  def set_up(n, user)

  	food_category = %W(fruits vegetables dairy grains fish_poultry_pork beef_lamb)
  	food_category_size = food_category.size

    # set up a random generator for carbon footprint
    cfp = Random.new


   

    # create n meal days
    for i in 0..n 
  	  
  	  # create meal day
  	  @meal_day = MealDay.create(user: user, 
    	  date: Time.zone.now - i.day, #Time.zone.today
    	  carbon_footprint: i + 35
      )



  
      # create 7 food 
      for j in 0..7

        

        @food_type = FoodType.find_or_create_by!(category: j % food_category_size) do |ft|
        
          # generate a random carbon footprint between 0 to 50
        	ft.carbon_footprint = cfp.rand(50.0) 
        	ft.icon = "#{food_category[j % food_category_size]}.png" 
        	ft.name = food_category[j % food_category_size]
          ft.average_size = cfp.rand(50.0) * 2
        end

        food = Food.create(size: cfp.rand(2.0), food_type: @food_type, meal_day: @meal_day)

      end

    end
  	
  end



  desc "test carbon footprint method from user model"
  task test_user_model_cfp_method: :environment do

    # generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    if ARGV.size != 2 
      puts "Error! Please provide proper parameters to your command. \n\nUsage: rake md_test:test_user_model_cfp_method user_email\n"
      puts "Example: rake md_test:test_user_model_cfp_method yong@mydomino.com\n"
      exit 1
    end

    user_email = ARGV[1]

    puts "\n User email is #{user_email}\n"

    begin
      user = User.find_by!(email: user_email)

      #set up date range
      start_date = Time.zone.today - 60.days
      end_date = Time.zone.today 

      puts "Total Carbon footprint for the period is #{user.get_fat_cf(start_date, end_date)}"
      puts "\nCarbon footprint for the date #{end_date} is #{user.get_fat_cf(end_date)}"

    rescue ActiveRecord::RecordNotFound
      puts "\n Error: user with email #{user_email} is not found. \nPlease run rake csv:create_corporate_and_admin to create the test user. Program exit.\n"
      exit
    end


  end

  desc "test leader board ranking for carbon footprint"
  task test_leader_board_cfp: :environment do

    # generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    
    if ARGV.size != 2 
      puts "Error! Please provide proper parameters to your command. \n\nUsage: rake md_test:test_leader_board_cfp organization_name\n"
      puts "Example: rake md_test:test_leader_board_cfp MyDomino\n"
      exit 1
    end

    # retrieve the org name
    org_name = ARGV[1]

    puts "Organization name is #{org_name}.\n" 

    # find an organization
    begin
      organization = Organization.find_by!(name: org_name)
    rescue Exception => e  
      puts "\nError! #{e.message}. Please note that the organization name is case sensitive."
      exit
    end


    users = User.where(["organization_id = ?", organization.id])

    #set up date range
    start_date = Time.zone.today 
    end_date = Time.zone.today - 60.days

    # refresh the total reward points
    users.each do |u|

      u.get_fat_reward_points(start_date, end_date)
      
    end


  
    users = User.where(["organization_id = ?", organization.id]).order("fat_reward_points DESC").limit(8)

    puts "First 8 top users in leader board are ...."
    # print user score in order
    users.each do |u|

      puts "User: #{u.email} Reward Points: #{u.fat_reward_points}"
    end


  end



  desc "generate_user_reward_points"
  task test_generate_user_reward_points: :environment do

    # generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    
    #if ARGV.size != 2 
    #  puts "Error! Please provide proper parameters to your command. \n\nUsage: rake md_test:test_generate_user_reward_points\n"
    #  puts "Example: rake md_test:test_generate_user_reward_points\n"
    #  exit 1
    #end
#
    #user_email = ARGV[1]
    org_name = 'MyDomino'
    org_name = org_name.downcase

    for user_email in %W(yong@#{org_name}.com johnp@#{org_name}.com marcian@#{org_name}.com jimmy@#{org_name}.com
      rosana@#{org_name}.com stephen@#{org_name}.com mel@#{org_name}.com admin@#{org_name}.com info@#{org_name}.com)

      puts "\n User email is #{user_email}\n"
  
  
      begin
  
        user = User.find_by!(email: user_email)
        #user = User.find_by!(email: 'yong@mydomino.com')
  
      rescue ActiveRecord::RecordNotFound
        puts "\n Error: user with email #{user_email} is not found. \nPlease run rake md_test:mydomino_create_corporate_and_admin to create the test user. Program exit.\n"
        exit
      end
      
  
      # test ...
  
      #set up date range
      start_date = Time.zone.today 
      end_date = Time.zone.today - 60.days
  
      date_range = end_date..start_date
  
      # set up a random generator
      plog = Random.new
  
      action_type = [PointsLog::SIGN_IN_EACH_DAY, FatCompetition::TRACK_FOOD_LOG, PointsLog::CLICK_ARTICLE_LINK, 
        PointsLog::CONTACT_CONCIERGE, PointsLog::SHARE_ARTICLE, FatCompetition::BEAT_CFP_EMISSION, 
        FatCompetition::EAT_NO_BEEF_LAMB_A_DAY, FatCompetition::EAT_NO_DAIRY_A_DAY]    
  
  
  
      date_range.each do |date|
  
        # generate an action point log
        for i in 0..5
  
          index = plog.rand(action_type.size-1)
  
          p_log = PointsLog.find_or_create_by!(user: user,
            point_type: action_type[index], point_date: date) do |pl| 
      
              pl.user = user
              pl.point_type = action_type[index]
              pl.point_date = date
              pl.desc = action_type[index]
              pl.point =  plog.rand(15)
        
            end
  
          p_log.save!
          puts "Pointslog #{p_log.inspect} is saved.\n"
  
        end
      end

      puts "\n\n=========================================================\n\n"
    end

  end


  desc "test remove_user_reward_points"
  task test_remove_user_reward_points: :environment do

    # generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    
    #if ARGV.size != 2 
    #  puts "Error! Please provide proper parameters to your command. \n\nUsage: rake md_test:test_remove_user_reward_points\n"
    #  puts "Example: rake md_test:test_remove_user_reward_points\n"
    #  exit 1
    #end
#
    #user_email = ARGV[1]
    org_name = 'MyDomino'
    org_name = org_name.downcase

    for user_email in %W(yong@#{org_name}.com johnp@#{org_name}.com marcian@#{org_name}.com jimmy@#{org_name}.com
      rosana@#{org_name}.com stephen@#{org_name}.com mel@#{org_name}.com admin@#{org_name}.com info@#{org_name}.com)

      puts "\n User email is #{user_email}\n"
  
  
      begin
  
        user = User.find_by!(email: user_email)
        #user = User.find_by!(email: 'yong@mydomino.com')
  
      rescue ActiveRecord::RecordNotFound
        puts "\n Error: user with email #{user_email} is not found. \nPlease run rake md_test:mydomino_create_corporate_and_admin to create the test user. Program exit.\n"
        exit
      end
      
  
      # test ...
  
      #set up date range
      start_date = Time.zone.today 
      end_date = Time.zone.today - 60.days
  
      date_range = end_date..start_date
  
      # set up a random generator
      plog = Random.new
  
      action_type = [PointsLog::SIGN_IN_EACH_DAY, FatCompetition::TRACK_FOOD_LOG, PointsLog::CLICK_ARTICLE_LINK, 
        PointsLog::CONTACT_CONCIERGE, PointsLog::SHARE_ARTICLE, FatCompetition::BEAT_CFP_EMISSION, 
        FatCompetition::EAT_NO_BEEF_LAMB_A_DAY, FatCompetition::EAT_NO_DAIRY_A_DAY]    
  
  
  
      date_range.each do |date|
  
        # generate an action point log
        for i in 0..2
  
          index = plog.rand(action_type.size-1)
  
          p_log = PointsLog.find_by(user: user, point_date: date) 
  
          # delete the record
          #PointsLog.delete(p_log.id) if p_log != nil

          # note: destroy will invoke the call_back hook, delete will not!!
          PointsLog.destroy(p_log.id) if p_log != nil


          puts "Pointslog #{p_log.inspect} is deleted.\n"
  
        end
      end

      puts "\n\n=========================================================\n\n"
    end

  end



  desc "test_update_user_reward_points"
  task test_update_user_reward_points: :environment do

    # generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    
    #if ARGV.size != 2 
    #  puts "Error! Please provide proper parameters to your command. \n\nUsage: rake md_test:test_update_user_reward_points\n"
    #  puts "Example: rake md_test:test_update_user_reward_points\n"
    #  exit 1
    #end
#
    #user_email = ARGV[1]
    org_name = 'MyDomino'
    org_name = org_name.downcase

    for user_email in %W(yong@#{org_name}.com johnp@#{org_name}.com marcian@#{org_name}.com jimmy@#{org_name}.com
      rosana@#{org_name}.com stephen@#{org_name}.com mel@#{org_name}.com admin@#{org_name}.com info@#{org_name}.com)

      puts "\n User email is #{user_email}\n"
  
  
      begin
  
        user = User.find_by!(email: user_email)
        #user = User.find_by!(email: 'yong@mydomino.com')
  
      rescue ActiveRecord::RecordNotFound
        puts "\n Error: user with email #{user_email} is not found. \nPlease run rake md_test:mydomino_create_corporate_and_admin to create the test user. Program exit.\n"
        exit
      end
      
  
      # test ...
  
      #set up date range
      start_date = Time.zone.today 
      end_date = Time.zone.today - 60.days
  
      date_range = end_date..start_date
  
      # set up a random generator
      plog = Random.new
  
      action_type = [PointsLog::SIGN_IN_EACH_DAY, FatCompetition::TRACK_FOOD_LOG, PointsLog::CLICK_ARTICLE_LINK, 
        PointsLog::CONTACT_CONCIERGE, PointsLog::SHARE_ARTICLE, FatCompetition::BEAT_CFP_EMISSION, 
        FatCompetition::EAT_NO_BEEF_LAMB_A_DAY, FatCompetition::EAT_NO_DAIRY_A_DAY]    
  
  
  
      date_range.each do |date|
  
        # generate an action point log
        for i in 0..5
  
          index = plog.rand(action_type.size-1)

          puts "Finding points...."
  
          p_log = PointsLog.find_by(user: user, point_date: date)

          if p_log != nil

            p_log.user = user
            p_log.point_type = action_type[index]
            p_log.point_date = date
            p_log.desc = action_type[index]
            p_log.point =  plog.rand(15)

            p_log.save!
            puts "Pointslog #{p_log.inspect} is saved.\n"

          end
  
        end
      end

      puts "\n\n=========================================================\n\n"
    end

  end
































  desc "show MyDomino users"
  task show_users: :environment  do

    organization = Organization.find_by!(name: 'MyDomino')
    users = User.where(["organization_id = ?", organization.id])
    
    users.each do |u|
      
      puts "ID: #{u.id}. Name: #{u.profile.first_name}. Email: #{u.email}"
    end
    
  end




    

	
end