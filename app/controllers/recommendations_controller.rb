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

  def create
    @recommendation = Recommendation.new(recommendation_params)
    @recommendation.concierge = current_concierge
    @recommendation.recommendable_type = "AmazonProduct"
    if @recommendation.save
      redirect_to amazon_storefront_path @recommendation.amazon_storefront
    else

    end
  end

  private

  def recommendation_params
    params.require(:recommendation).permit(:comment, :amazon_storefront_id, :recommendable_id)
  end 

end