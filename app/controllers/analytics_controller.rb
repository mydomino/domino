class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  layout 'concierge'

  def show
    authorize :analytic, :show?
    @filter = params[:filter]
    if(@filter == 'all')
      @recent_events = Recommendation.done.includes(:recommendable, :dashboard).timestamped.order(:updated_at).last(50)
    else
      @filter = 'mine'
      @recent_events = Recommendation.done.includes(:recommendable, :dashboard).timestamped.where(concierge_id: current_user.id).order(:updated_at).last(50)
    end
    @dashboard_count = Dashboard.all.count
    @recommendations_count = Recommendation.all.count
    @recommendations_completed_count = Recommendation.done.count
    @recommendations = Recommendation.all
    @dashboards_by_state = Dashboard.joins('join leads on leads.email = dashboards.lead_email').where('leads.state IS NOT NULL').group("leads.state").order("COUNT(leads.state) DESC").count
  end
end