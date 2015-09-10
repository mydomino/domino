class AnalyticsController < ApplicationController
  before_action :authenticate_concierge!
  layout 'concierge'


  def show
    @storefront_count = AmazonStorefront.all.count
    @recommendations_count = Recommendation.all.count
    @recommendations_completed_count = Recommendation.done.count
  end
end