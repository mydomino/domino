# to call this, use: CalculateFatTotalPointJob.perform_later id
class CalculateFatTotalPointJob <  ActiveJob::Base
  queue_as :default

  def perform(organization)

     begin

       puts "*********** CalculateFatTotalPointJob is execute for org_id: #{organization.id}\n\n"
       #organization = Organization.find_by!(id: org_id)

       users = User.where(organization: organization)

       #set up date range
       start_date = Time.zone.today 
       end_date = Time.zone.today - 60.days
   
       # refresh the total reward points
       users.each do |u|
         # calculate user reward points during the period and save it to the user's member variable
         u.get_fat_reward_points(start_date, end_date)
       end


     rescue StandardError => error
      
      puts "Exception is caught in CalculateFatTotalPointJob#perform method! Error is #{e.message}"
     end
    
  end
end