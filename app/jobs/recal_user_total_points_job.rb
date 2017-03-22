# to call this, use: RecalUserTotalPointsJob.perform_later id
class RecalUserTotalPointsJob <  ActiveJob::Base
  queue_as :default

  def perform(user)

     begin

       puts "*********** RecalUserTotalPointsJob is run for user_id: #{user.id}\n\n"
       
       #set up date range 
       # get the start day and end day of the current work week
       # start_day is the end of the work week. In our case, it is Sunday
       # end_day is the start of the work week. In our case, it is Monday
       end_date =  Time.zone.today - Time.zone.today.wday + 1
       start_date = end_date + 6
       
       
       total_start_date = Time.zone.today 
       total_end_date = Time.zone.today - 60.days
   
       # refresh the total reward points
       
       # calculate user reward points during the period and save it to the user's member variable
       user.get_fat_reward_points(start_date, end_date)

       user.get_total_fat_reward_points(total_start_date, total_end_date)
       

     rescue StandardError => error
      
      puts "Exception is caught in RecalUserTotalPointsJob#perform method! Error is #{error.message}"
     end
    
  end
end