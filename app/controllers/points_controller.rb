class PointsController < ApplicationController
	rescue_from ActionController::RedirectBackError, with: :redirect_to_default
  
  def add_watch_ttc_moive_points

  	PointsLog.add_point(current_user, PointsLog::WATCH_TTC_MOVIE, "Watch Time to Choose Movie", PointsLog::WATCH_TTC_MOVIE_POINTS, Time.zone.now.to_date)

    # stay on the same page
  	#redirect_to :back
    redirect_to myhome_path
  end


  private

  def redirect_to_default
    redirect_to root_path
  end

end
