class RecommendationsController < ApplicationController
  before_action :authenticate_concierge!, except: :complete
  layout 'concierge'

  def complete
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: true)
    #flash[:success] = 'You\'ve marked that recommendation as completed! <a href="'<<recommendation_undo_complete_path(@recommendation)<<'">Undo</a>'.html_safe
    redirect_to @recommendation.amazon_storefront
  end

  def undo
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: false)
    redirect_to @recommendation.amazon_storefront
  end

  def new
    @storefront = AmazonStorefront.friendly.find(params[:amazon_storefront_id])
    @recommendation = Recommendation.new
  end

  def create
    @storefront = AmazonStorefront.friendly.find(params[:amazon_storefront_id])
    @recommendation = Recommendation.new(recommendation_params)
    @recommendation.concierge = current_concierge
    if @recommendation.save
      redirect_to amazon_storefront_path @recommendation.amazon_storefront
    else

    end
  end

  private

  def recommendation_params
    params.require(:recommendation).permit(:comment, :global_recommendable).merge(amazon_storefront_id: @storefront.id)
  end 

end