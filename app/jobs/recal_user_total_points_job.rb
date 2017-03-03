# to call this, use: RecalUserTotalPointsJob.perform_later id
class RecalUserTotalPointsJob <  ActiveJob::Base
  queue_as :default

  def perform(user)

     begin

       puts "*********** RecalUserTotalPointsJob is run for user_id: #{user.id}\n\n"
       
       #set up date range
       start_date = Time.zone.today 
       end_date = Time.zone.today - 60.days
   
       # refresh the total reward points
       
       # calculate user reward points during the period and save it to the user's member variable
       user.get_fat_reward_points(start_date, end_date)
       

     rescue StandardError => error
      
      puts "Exception is caught in RecalUserTotalPointsJob#perform method! Error is #{e.message}"
     end
    
  end
end