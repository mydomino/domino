class AnalyticsController < ApplicationController
  before_action :authenticate_concierge!
  layout 'concierge'


  def show
    @dashboard_count = Dashboard.all.count
    @recommendations_count = Recommendation.all.count
    @recommendations_completed_count = Recommendation.done.count
  end
end