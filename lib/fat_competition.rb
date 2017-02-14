module FatCompetition

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
    PointsLog.add_point(user, "TAKE_FOOD_LOG", "Daily FAT tracking", 5, Date.today)

    # Award Eat no dairy
    if !meal_day.foods.any? {|a| a.food_type.category == "dairy"}
      PointsLog.add_point(user, "EAT_NO_DAIRY_A_DAY", "Ate no dairy", 5, Date.today)
    end
   
     # Award Eat no beef or lamb
    if !meal_day.foods.any? {|a| a.food_type.category == "beef_lamb"}
      PointsLog.add_point(user, "EAT_NO_BEEF_LAMB_A_DAY", "Ate no beef or lamb", 10, Date.today)
    end
 
     # Award Beat US average CO2 emissions for day
     # NOTE: This point awarding is different from the others, as this point value is a range
     # !!NEED TO FIGURE OUT HOW TO HANDLE POINTTYPE W/ RANGES !!
     percent_average_emission = 1 - (meal_day.carbon_footprint / 6.2).round(1)
 
     # user is eligible for a point
     # 1 pt per percent below average
     if percent_average_emission >= 0.1  
        pts = (percent_average_emission * 10 * PointType.beat_us_avg_emission.points).to_i
        PointsLog.add_point(user, "BEAT_CFP_EMISSION", "Beat avg cfp emission", pts, Date.today)
     end
  end
end