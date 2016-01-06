class AnalyticsController < ApplicationController
  before_action :authenticate_concierge!
  layout 'concierge'

  def show
    @filter = params[:filter]
    if(@filter == 'all')
      @recent_events = Recommendation.done.timestamped.order(:updated_at).last(10)
    else
      @filter = 'mine'
      @recent_events = Recommendation.done.timestamped.where(concierge_id: current_concierge.id).order(:updated_at).last(10)
    end
    @dashboard_count = Dashboard.all.count
    @recommendations_count = Recommendation.all.count
    @recommendations_completed_count = Recommendation.done.count
    @recommendations = Recommendation.all
    @dashboards_by_state = Dashboard.joins('join leads on leads.email = dashboards.lead_email').where('leads.state IS NOT NULL').group("leads.state").count
  end

end