class RecommendationsController < ApplicationController
  before_action :authenticate_concierge!, except: [:complete, :undo]
  layout 'concierge'

  def complete
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: true)
    flash[:success] = 'You\'ve marked that recommendation as completed! <a class="pull-right" data-method="delete" href="'<<recommendation_undo_complete_path(@recommendation)<<'">Undo</a>'.html_safe
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
    @recommendation = Recommendation.new(create_recommendation_params)
    @recommendation.concierge = current_concierge
    if @recommendation.save
      redirect_to amazon_storefront_path @recommendation.amazon_storefront
    else
      flash[:alert] = 'The storefront already contains that recommendation'
      render :new
    end
  end

  def update
    @recommendation = Recommendation.find(params[:id])
    @recommendation.update_attributes(update_recommendation_params)
    redirect_to @recommendation.amazon_storefront
  end

  def bulk_update
    @storefront = AmazonStorefront.friendly.find(params[:amazon_storefront_id])
    if(!params[:amazon_storefront].nil?)
      new_product_recommendations = params[:amazon_storefront][:amazon_product_ids]
      @storefront.amazon_product_ids = params[:amazon_storefront][:amazon_product_ids]
      new_task_recommendations = params[:amazon_storefront][:amazon_product_ids]
      @storefront.task_ids = params[:amazon_storefront][:task_ids]
    else
      @storefront.amazon_product_ids = []
      @storefront.task_ids = []
    end
    redirect_to @storefront
  end

  def destroy
    @recommendation = Recommendation.find(params[:id])
    @storefront = @recommendation.amazon_storefront
    @recommendation.delete
    flash[:notice] = 'Recommendation Removed'
    redirect_to @storefront
  end

  private

  def create_recommendation_params
    params.require(:recommendation).permit(:comment, :global_recommendable).merge(amazon_storefront_id: @storefront.id)
  end

  def update_recommendation_params
    params.require(:recommendation).permit(:comment)
  end

end