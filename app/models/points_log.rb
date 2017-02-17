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

#require File.expand_path("../../../lib/fat_competition", __FILE__)

class PointsLog < ActiveRecord::Base

  # define ACTIONS type CONTANT
  SIGN_IN_EACH_DAY        = 'SIGN_IN_EACH_DAY'
  CLICK_ARTICLE_LINK      = 'CLICK_ARTICLE_LINK'
  CONTACT_CONCIERGE       = 'CONTACT_CONCIERGE'
  SHARE_ARTICLE           = 'SHARE_ARTICLE'
  COMMENT_ARTICLE         = 'COMMENT_ARTICLE'

  # define Action Point Constant 
  SIGN_IN_EACH_DAY_POINTS         = 5
  CLICK_ARTICLE_LINK_POINTS       = 5
  CONTACT_CONCIERGE_POINTS        = 10
  SHARE_ARTICLE_POINTS            = 10
  COMMENT_ARTICLE_POINTS          = 10


  belongs_to :user

  validates :point_date, :point_type, :point, :user, presence: true

  # /get_points/
  # Purpose: Get user's total points by group
  def get_points_by_group
    # self.point_entries.inject(0){|sum, entry| sum += entry.point_type.points }
  end

  def self.add_point(user, point_type, desc, point, point_date)

  	
    # these action types are allowed only to be rewarded once per day
    if [PointsLog::SIGN_IN_EACH_DAY, FatCompetition::TRACK_FOOD_LOG, FatCompetition::BEAT_CFP_EMISSION, 
      FatCompetition::EAT_NO_BEEF_LAMB_A_DAY, FatCompetition::EAT_NO_DAIRY_A_DAY].include?(point_type)

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

    return p_log
  end


  def self.remove_point(user, point_type, point_date)

    p_log = PointsLog.find_by(user: user,
        point_type: point_type, point_date: point_date) 

    if (p_log != nil)
      PointsLog.destroy(p_log.id)
    end


    return true 
  end


  def self.update_point(user, point_type, desc, point, point_date)

    p_log = PointsLog.find_by(user: user,
        point_type: point_type, point_date: point_date) 

    if (p_log != nil)

      PointsLog.update(p_log.id, point: point, desc: desc)
    end

    return true
  end


  def self.has_point?(user, point_type, point_date)

    p_log = PointsLog.find_by(user: user,
        point_type: point_type, point_date: point_date) 

    found = (p_log != nil)? true : false

    return found

  end

end
