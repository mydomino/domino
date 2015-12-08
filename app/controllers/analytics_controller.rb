class AnalyticsController < ApplicationController
  before_action :authenticate_concierge!
  layout 'concierge'

  def show
    @dashboard_count = Dashboard.all.count
    @recommendations_count = Recommendation.all.count
    @recommendations_completed_count = Recommendation.done.count
    @recommendations = Recommendation.all
    @recent_events = Recommendation.done.timestamped.last(10)
  end

end