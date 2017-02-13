module FatCompetition

  # /self.award_points/
  # Purpose: Award a user with points for a given meal_day
  def self.award_points(meal_day)
    user = meal_day.user
    point_log = user.point_log

    # Pts to award
    # - Log food for day
    # - Eat no dairy
    # - Eat no beef or lamb
    # - Beat US average CO2 emissions for day

    # Award log food for day
    user.award_points(PointType.log_food_fod_day)

  end
end