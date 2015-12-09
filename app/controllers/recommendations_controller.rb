class RecommendationsController < ApplicationController
  before_action :authenticate_concierge!, except: [:complete, :undo]
  layout 'concierge'

  def complete
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: true)
    Heap.event("Recommendation Completed", @recommendation.dashboard.lead_email)
    flash[:success] = 'You\'ve marked that recommendation as completed! <a class="pull-right" data-method="delete" href="'<<recommendation_undo_complete_path(@recommendation)<<'">Undo</a>'.html_safe
    redirect_to @recommendation.dashboard
  end

  def undo
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: false)
    redirect_to @recommendation.dashboard
  end

  def new
    @storefront = Dashboard.friendly.find(params[:dashboard_id])
    @recommendation = Recommendation.new
  end

  def create
    @storefront = Dashboard.friendly.find(params[:dashboard_id])
    @recommendation = Recommendation.new(create_recommendation_params)
    @recommendation.concierge = current_concierge
    if @recommendation.save
      redirect_to dashboard_path @recommendation.dashboard
    else
      flash[:alert] = 'The storefront already contains that recommendation'
      render :new
    end
  end

  def update
    @recommendation = Recommendation.find(params[:id])
    @recommendation.update_attributes(update_recommendation_params)
    redirect_to @recommendation.dashboard
  end

  def bulk_update
    @storefront = Dashboard.friendly.find(params[:dashboard_id])
    if(!params[:dashboard].nil?)
      new_product_recommendations = params[:dashboard][:product_ids]
      @storefront.product_ids = params[:dashboard][:product_ids]
      new_task_recommendations = params[:dashboard][:product_ids]
      @storefront.task_ids = params[:dashboard][:task_ids]
    else
      @storefront.product_ids = []
      @storefront.task_ids = []
    end
    redirect_to @storefront
  end

  def destroy
    @recommendation = Recommendation.find(params[:id])
    @storefront = @recommendation.dashboard
    @recommendation.delete
    flash[:notice] = 'Recommendation Removed'
    redirect_to @storefront
  end

  private

  def create_recommendation_params
    params.require(:recommendation).permit(:comment, :global_recommendable).merge(dashboard_id: @storefront.id)
  end

  def update_recommendation_params
    params.require(:recommendation).permit(:comment)
  end

end