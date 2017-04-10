# to call this, use: CalculateFatTotalPointJob.perform_later id
class CalculateFatTotalPointJob <  ActiveJob::Base
  queue_as :default

  def perform(organization)

     begin

       puts "*********** CalculateFatTotalPointJob is execute for org_id: #{organization.try(:id)}\n\n"
       
       users = User.where(organization: organization)


       # set up date range 
       # get the start day and end day of the current work week
       # start_day is the end of the work week. In our case, it is Sunday
       # end_day is the start of the work week. In our case, it is Monday
       end_date =  Time.zone.today - Time.zone.today.cwday + 1
       start_date = end_date + 6
       
       
       total_start_date = Time.zone.today 
       total_end_date = Time.zone.today - 60.days
   
       
       # refresh the total reward points
       users.each do |u|
         # calculate user reward points during the period and save it to the user's member variable
         u.get_fat_reward_points(start_date, end_date)
         u.get_total_fat_reward_points(total_start_date, total_end_date)
       end


     rescue StandardError => error
      
      puts "Exception is caught in CalculateFatTotalPointJob#perform method! Error is #{error.message}"
     end
    
  end
end