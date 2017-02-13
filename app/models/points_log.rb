# == Schema Information
#
# Table name: points_logs
#
#  id         :integer          not null, primary key
#  point_date :date
#  point_type :string
#  desc       :string
#  point      :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_points_logs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_f97c67f538  (user_id => users.id)
#

class PointsLog < ActiveRecord::Base
  # def get_points
  #   # return all the points for the user
  # end

  # def award_points(user, point_type)
  #   #logic to see if pts already awarded
  # end

  # define ACTIONS type CONTANT
  SIGN_IN_EACH_DAY        = 'SIGN_IN_EACH_DAY'
  TAKE_FOOD_LOG           = 'TAKE_FOOD_LOG'
  CLICK_ARTICLE_LINK      = 'CLICK_ARTICLE_LINK'
  CONTACT_CONCIERGE       = 'CONTACT_CONCIERGE'
  SHARE_ARTICLE           = 'SHARE_ARTICLE'
  BEAT_CFP_EMISSION       = 'BEAT_CFP_EMISSION'
  EAT_NO_BEEF_LAMB_A_DAY  = 'EAT_NO_BEEF_LAMB_A_DAY'
  EAT_NO_DAIRY_A_DAY      = 'EAT_NO_DAIRY_A_DAY' 

  # Group = "TRANSPORTATION"
  # => types: ["BIKE_TO_WORK", "RIDE_PUBLIC_TRANSIT"]
  
  # Group = "FAT"
  # => types: ["EAT_NO_DAIRY_A_DAY", "EAT_NO_BEEF_LAMB_A_DAY"]

  # Group = "Engagement"
  # => types: ["SIGN_IN_EACH_DAY", "CLICK_ARTICLE_LINK ",  "CONTACT_CONCIERGE"]

  belongs_to :user


  validates :point_date, :point_type, :point, :user, presence: true

  # /get_points/
  # Purpose: Get user's total points by group
  def get_points_by_group
    # self.point_entries.inject(0){|sum, entry| sum += entry.point_type.points }
  end

  def self.add_point(user, point_type, desc, point, point_date)

  	
    # these action types are allowed only to be rewarded once per day
    if [PointsLog::SIGN_IN_EACH_DAY, PointsLog::TAKE_FOOD_LOG, PointsLog::BEAT_CFP_EMISSION, 
      PointsLog::EAT_NO_BEEF_LAMB_A_DAY, PointsLog::EAT_NO_DAIRY_A_DAY].include?(point_type)

  	  p_log = PointsLog.find_or_create_by!(user: user,
  	  	point_type: point_type, point_date: point_date) do |pl| 
  
      	pl.user = user
      	pl.point_type = point_type
      	pl.point_date = point_date
      	pl.desc = desc
      	pl.point = point
  
      end

    else

    	p_log = PointsLog.create!(user: user, point_type: point_type, desc: desc, point: point, point_date: point_date)
    
    end
    
  end


end
