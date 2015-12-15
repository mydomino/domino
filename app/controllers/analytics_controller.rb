class AnalyticsController < ApplicationController
  before_action :authenticate_concierge!
  layout 'concierge'

  def show
    @filter = params[:filter]
    if(@filter == 'all')
      @recent_events = Recommendation.done.timestamped.last(10)
    else
      @filter = 'mine'
      @recent_events = Recommendation.done.timestamped.where(concierge_id: current_concierge.id).last(10)
    end
    @dashboard_count = Dashboard.all.count
    @recommendations_count = Recommendation.all.count
    @recommendations_completed_count = Recommendation.done.count
    @recommendations = Recommendation.all
  end

end