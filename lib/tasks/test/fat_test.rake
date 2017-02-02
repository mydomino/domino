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

  	user.meal_days.where(["date >= ? and date <= ?", start_date, end_date]).each do |meal_day|

      puts "meal_day: #{meal_day.date}\n"

      meal_day.meals

    end


  	



  	# 

  end




  def set_up(n, user)

  	food_category = %W(fruits vegetables dairy grains fish_poultry_pork beef_lamb)
  	food_category_size = food_category.size

    meal_portion = %W(small medium large)
    meal_portion_size = meal_portion.size

    @meal_type = MealType.create(caloric_budget: 60, 
        name: 'breakfast'       
    )



    # create n meal days
    for i in 0..n 
  	  
  	  # create meal day
  	  @meal_day = MealDay.create(user: user, 
    	  date: Time.zone.now - i.day, #Time.zone.today
    	  carbon_footprint: i + 35
      )
  
      @meal = Meal.create(size: meal_portion[i % 3], 
      	meal_day:  @meal_day, 
      	meal_type: @meal_type
      )
  
      # create 7 food 
      for j in 0..7

        @food_type = FoodType.find_or_create_by!(category: food_category[i % food_category_size]) do |ft|
        
        	ft.carbon_footprint = 32.5+i, 
        	ft.icon = "#{food_category[i % food_category_size]}.png", 
        	ft.name = food_category[i % food_category_size]
        end
    
        food = Food.create(portion: 38+i, food_type: @food_type, meal: @meal)

      end

    end
  	
  end

	
end