module FatCompetition

  # FAT specific point values
  TRACK_FOOD_LOG_POINTS           = 10
  BEAT_CFP_EMISSION_POINTS        = 1
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

    # Award log food for day
    award_track_food_log(meal_day)

    award_ate_no_dairy(meal_day)
    
    award_ate_no_beef_or_lamb(meal_day)
   
    award_beat_avg_cfp(meal_day)
  end

  def self.award_track_food_log(meal_day)
    if !PointsLog.has_point?(meal_day.user, "BEAT_CFP_EMISSION", meal_day.date)
      PointsLog.add_point(meal_day.user, "TRACK_FOOD_LOG", "Daily FAT tracking",  TRACK_FOOD_LOG_POINTS, meal_day.date)
    end
  end
  private_class_method :award_track_food_log

  def self.award_ate_no_dairy(meal_day)
    if !meal_day.foods.any? {|a| a.food_type.category == "dairy"}
      # award point if user has not already earned it
      if !PointsLog.has_point?(meal_day.user, "EAT_NO_DAIRY_A_DAY", meal_day.date)
        PointsLog.add_point(meal_day.user, "EAT_NO_DAIRY_A_DAY", "Ate no dairy", EAT_NO_DAIRY_A_DAY_POINTS, meal_day.date)
      end
    else 
      # Remove point if they did eat beef or lamb
      # NOTE: We don't need to check if the point exists prior to removal b/c
      #  in PointsLog#remove_point nil query returns are accounted for
        PointsLog.remove_point(meal_day.user, "EAT_NO_DAIRY_A_DAY", meal_day.date)
    end
  end
  private_class_method :award_ate_no_dairy


  def self.award_ate_no_beef_or_lamb(meal_day)
     if !meal_day.foods.any? {|a| a.food_type.category == "beef_lamb"}
      # award point if user has not already earned it
      if !PointsLog.has_point?(meal_day.user, "EAT_NO_BEEF_LAMB_A_DAY", meal_day.date)
        PointsLog.add_point(meal_day.user, "EAT_NO_BEEF_LAMB_A_DAY", "Ate no beef or lamb", EAT_NO_BEEF_LAMB_A_DAY_POINTS, meal_day.date)
      end
    else # Remove point if they did eat beef or lamb
      PointsLog.remove_point(meal_day.user, "EAT_NO_BEEF_LAMB_A_DAY", meal_day.date)
    end
  end
  private_class_method :award_ate_no_beef_or_lamb


  def self.award_beat_avg_cfp(meal_day)
    # user is not elible for points
    # Their carbon footprint exceeds 6.2 kg
    if meal_day.carbon_footprint >= 6.2
      PointsLog.remove_point(meal_day.user, "BEAT_CFP_EMISSION", meal_day.date)
    else
      # user is eligible for a point
      # 1 pt per 10 percent below average
      percent_average_emission = 1 - (meal_day.carbon_footprint / 6.2).round(1)

      if percent_average_emission >= 0.1 && percent_average_emission < 1.0
        pts = ( percent_average_emission * 10 * BEAT_CFP_EMISSION_POINTS ).to_i
        if PointsLog.has_point?(meal_day.user, "BEAT_CFP_EMISSION", meal_day.date)
          PointsLog.update_point(meal_day.user, "BEAT_CFP_EMISSION", "Beat avg cfp emission", pts, meal_day.date)
        else
          PointsLog.add_point(meal_day.user, "BEAT_CFP_EMISSION", "Beat avg cfp emission", pts, meal_day.date)
        end
      end
    end
  end
  private_class_method :award_beat_avg_cfp

end