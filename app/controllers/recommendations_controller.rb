class RecommendationsController < ApplicationController
  before_action :authenticate_concierge!, except: :complete

  def complete
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: true)
    redirect_to @recommendation.amazon_storefront
  end

  def new
    @recommendation = Recommendation.new
  end

end