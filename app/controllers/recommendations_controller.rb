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
    @recommendation = Recommendation.new(recommendation_params)
    @recommendation.concierge = current_concierge
    if @recommendation.save
      redirect_to amazon_storefront_path @recommendation.amazon_storefront
    else
      flash[:alert] = 'The storefront already contains that recommendation'
      render :new
    end
  end

  def bulk_update
    @storefront = AmazonStorefront.friendly.find(params[:amazon_storefront_id])
    if(params[:amazon_storefront][:amazon_product_ids].present?)
      params[:amazon_storefront][:amazon_product_ids].each do |product|
        Recommendation.create(recommendable_id: product, recommendable_type: "AmazonProduct", amazon_storefront: @storefront)
      end
    end
    if(params[:amazon_storefront][:task_ids].present?)
      params[:amazon_storefront][:task_ids].each do |task|
        Recommendation.create(recommendable_id: task, recommendable_type: "Task", amazon_storefront: @storefront)
      end
    end
    redirect_to @storefront
  end

  def destroy
    @recommendation = Recommendation.find(params[:id])
    @amazon_storefront = @recommendation.amazon_storefront
    @recommendation.delete
    flash[:notice] = 'Recommendation Removed'
    redirect_to @amazon_storefront
  end

  private

  def recommendation_params
    params.require(:recommendation).permit(:comment, :global_recommendable).merge(amazon_storefront_id: @storefront.id)
  end

end