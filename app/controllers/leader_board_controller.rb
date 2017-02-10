class LeaderBoardController < ApplicationController
	before_action :authenticate_user!
  
  def cfp_ranking

    organization = current_user.organization

  	if organization.nil?

  		# find the default organization
  		organization = Organization.find_by!(name: 'MyDomino')
  	end

  	puts "Organization name is #{organization.name}.\n" 

    users = User.where(["organization_id = ?", organization.id])

    #set up date range
    start_date = Time.zone.today 
    end_date = Time.zone.today - 60.days

    # refresh the total reward points
    users.each do |u|

      # calculate user reward points during the period and save it to the user's member variable
      u.get_fat_reward_points(start_date, end_date)
      
    end

    @users = User.includes(:profile).where(["organization_id = ?", organization.id]).order("fat_reward_points DESC").first(8)

  end


end
