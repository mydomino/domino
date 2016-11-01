class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  layout 'concierge'

  def show
    authorize :analytic, :show?
    @recent_events = Recommendation.done.includes(:recommendable, :dashboard).timestamped.order(:updated_at).last(50)
    @dashboard_count = Dashboard.all.count
    @recommendations_count = Recommendation.all.count
    @recommendations_completed_count = Recommendation.done.count
    @dashboards_by_state = Dashboard.joins('join profiles on profiles.email = dashboards.lead_email').where('profiles.state IS NOT NULL').group("profiles.state").order("COUNT(profiles.state) DESC").count
  end
end