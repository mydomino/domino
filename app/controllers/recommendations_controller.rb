class RecommendationsController < ApplicationController
  def complete
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: true)
    redirect_to @recommendation.amazon_storefront
  end
end