namespace :md_test do

	desc "test for carbon footprint for a user"
  task test_user_cfp: :environment do

  	# generate an empty task for each argument pass in
    ARGV.each { |a| task a.to_sym do ; end }

    #puts "ARGV.size is #{ARGV.size}"
    
    if ARGV.size != 2 
      puts "Error! Please provide proper parameters to your command. \n\nUsage: rake md_test:test_user_cfp user_email\n"
      puts "Example. rake md_test:test_user_cfp yong@mydomino.com\n"
      exit 1
    end

    user_email = ARGV[1]

    puts "\n User email is #{user_email}\n"


    begin

    	#user = User.find_by!(email: user_email)
    	user = User.find_by!(email: 'yong@mydomino.com')

    rescue ActiveRecord::RecordNotFound
    	puts "\n Error: user with email #{user_email} is not found. \nPlease run rake csv:create_corporate_and_admin to create the test user. Program exit.\n"
    	exit
    end
    


  	
  	# set up the data set in database for testing 
  	set_up(5, user)

  	# test ...

  	#set up date range
  	start_date = Time.zone.today - 60.days
  	end_date = Time.zone.today

  	user.meal_days.where(["date >= ? and date <= ?", start_date, end_date])


  	



  	# 

  end




  def set_up(n, user)

  	food_category = %W(fruits vegetables dairy grains fish_poultry_pork beef_lamb)
  	food_category_size = food_category.size

    # create n meal days
    for i in 1..n 
  	  
  	  # create meal day
  	  @meal_day = MealDay.create(user: user, 
    	  date: Time.zone.now - i.day, #Time.zone.today
    	  carbon_footprint: i + 35
      )


      @meal_type = MealType.create(caloric_budget: 60, 
      	name: 'breakfast'       
      )
  
      @meal = Meal.create(size: Meal.small, 
      	meal_day:  @meal_day, 
      	meal_type: @meal_type
      )
  
      @food_type = FoodType.create(category: food_category[i % food_category_size], 
      	carbon_footprint: 32.5+i, 
      	icon: "#{food_category[i % food_category_size]}.png", 
      	name: food_category[i % food_category_size]
      )
  
      food = Food.create(portion: 38+i, food_type: @food_type, meal: @meal)

    end
  	
  end

	
end