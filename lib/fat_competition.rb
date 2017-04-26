module FatCompetition

  # FAT Logging grace period
  GRACE_PERIOD_DAY = 'wednesday'
  GRACE_PERIOD_HOUR = 23

  # define ACTIONS type CONSTANTS
  TRACK_FOOD_LOG            = 'TRACK_FOOD_LOG'
  BEAT_CFP_EMISSION         = 'BEAT_CFP_EMISSION'
  EAT_NO_BEEF_LAMB_A_DAY    = 'EAT_NO_BEEF_LAMB_A_DAY'
  EAT_NO_DAIRY_A_DAY        = 'EAT_NO_DAIRY_A_DAY'

  # FAT specific point values
  TRACK_FOOD_LOG_POINTS           = 10
  BEAT_CFP_EMISSION_POINTS        = 10
  EAT_NO_BEEF_LAMB_A_DAY_POINTS   = 10
  EAT_NO_DAIRY_A_DAY_POINTS       = 5

  # /self.award_points/
  # Purpose: Award a user with points for a given meal_day
  def self.award_points(meal_day)
    user = meal_day.user
    # Pts to award
    # - Log food for day
    # - Eat no dairy
    # - Eat no beef or lamb
    # - Beat US average CO2 emissions for day
    # if meal_day.carbon_footprint > 7
    #   meal_day.update(points: 0)
    #   return
    # end

    points = 0;
    
    points += award_track_food_log(meal_day)
    
    points += award_ate_no_dairy(meal_day)
    
    points += award_ate_no_beef_or_lamb(meal_day)
   
    points += award_beat_avg_cfp(meal_day)
    
    meal_day.update(points: points)
    
  end

  def self.award_track_food_log(meal_day)
    if !PointsLog.has_point?(meal_day.user, BEAT_CFP_EMISSION, meal_day.date)
      PointsLog.add_point(meal_day.user, TRACK_FOOD_LOG, "Daily FAT tracking",  TRACK_FOOD_LOG_POINTS, meal_day.date)
    end
    return TRACK_FOOD_LOG_POINTS
  end
  private_class_method :award_track_food_log

  def self.award_ate_no_dairy(meal_day)
    points = 0
    if !meal_day.foods.any? {|a| a.food_type.category == "dairy"}
      points = EAT_NO_DAIRY_A_DAY_POINTS
      # award point if user has not already earned it
      if !PointsLog.has_point?(meal_day.user, EAT_NO_DAIRY_A_DAY, meal_day.date)
        PointsLog.add_point(meal_day.user, EAT_NO_DAIRY_A_DAY, "Ate no dairy", EAT_NO_DAIRY_A_DAY_POINTS, meal_day.date)
      end
    else 
      # Remove point if they did eat beef or lamb
      # NOTE: We don't need to check if the point exists prior to removal b/c
      #  in PointsLog#remove_point nil query returns are accounted for
        PointsLog.remove_point(meal_day.user, EAT_NO_DAIRY_A_DAY, meal_day.date)
    end
    return points
  end
  private_class_method :award_ate_no_dairy


  def self.award_ate_no_beef_or_lamb(meal_day)
     points = 0
     if !meal_day.foods.any? {|a| a.food_type.category == "beef_lamb"}
      points = EAT_NO_BEEF_LAMB_A_DAY_POINTS
      # award point if user has not already earned it
      if !PointsLog.has_point?(meal_day.user, EAT_NO_BEEF_LAMB_A_DAY, meal_day.date)
        PointsLog.add_point(meal_day.user, EAT_NO_BEEF_LAMB_A_DAY, "Ate no beef or lamb", EAT_NO_BEEF_LAMB_A_DAY_POINTS, meal_day.date)
      end
    else # Remove point if they did eat beef or lamb
      PointsLog.remove_point(meal_day.user, EAT_NO_BEEF_LAMB_A_DAY, meal_day.date)
    end
    return points
  end
  private_class_method :award_ate_no_beef_or_lamb


  def self.award_beat_avg_cfp(meal_day)
    points = 0
    # user is not elible for points
    # Their carbon footprint exceeds 6.2 kg
    if meal_day.carbon_footprint >= 7
      PointsLog.remove_point(meal_day.user, BEAT_CFP_EMISSION, meal_day.date)
    else
      # user is eligible for a point
      # 1 point for each % below cfp
      percent_average_emission = (1-(meal_day.carbon_footprint)/7).round(2)
      if percent_average_emission >= 0.1 && percent_average_emission < 1.0
        pts = ( percent_average_emission * 100 ).to_i
        if PointsLog.has_point?(meal_day.user, BEAT_CFP_EMISSION, meal_day.date)
          PointsLog.update_point(meal_day.user, BEAT_CFP_EMISSION, "Beat avg cfp emission", pts, meal_day.date)
          points = pts
        else
          PointsLog.add_point(meal_day.user, BEAT_CFP_EMISSION, "Beat avg cfp emission", pts, meal_day.date)
          points = pts
        end
      end
    end
    return points
  end
  private_class_method :award_beat_avg_cfp

end
