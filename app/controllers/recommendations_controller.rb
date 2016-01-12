class RecommendationsController < ApplicationController
  before_action :authenticate_concierge!, except: [:complete, :undo]
  layout 'concierge'

  def complete
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: true, updated_by: current_concierge_maybe)
    Heap.event("Recommendation Completed", @recommendation.dashboard.lead_email, { recommendation_type: @recommendation.recommendable_type, recommendation_name: @recommendation.recommendable.name })
    flash[:success] = 'You\'ve marked that recommendation as completed! Completed recommendations are shown at the bottom of this page. <a class="pull-right" data-method="delete" href="'<<recommendation_undo_complete_path(@recommendation)<<'">Undo</a>'.html_safe
    redirect_to @recommendation.dashboard
  end

  def undo
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: false)
    redirect_to @recommendation.dashboard
  end

  def new
    @dashboard = Dashboard.friendly.find(params[:dashboard_id])
    @recommendation = Recommendation.new
  end

  def create
    @dashboard = Dashboard.friendly.find(params[:dashboard_id])
    @recommendation = Recommendation.new(create_recommendation_params)
    @recommendation.concierge = current_concierge
    if @recommendation.save
      redirect_to dashboard_path @recommendation.dashboard
    else
      flash[:alert] = 'The dashboard already contains that recommendation'
      render :new
    end
  end

  def update
    @recommendation = Recommendation.find(params[:id])
    @recommendation.update_attributes(update_recommendation_params)
    redirect_to @recommendation.dashboard
  end

  def bulk_update
    @dashboard = Dashboard.friendly.find(params[:dashboard_id])
    if(!params[:dashboard].nil?)
      new_product_recommendations = params[:dashboard][:product_ids]
      @dashboard.product_ids = params[:dashboard][:product_ids]
      new_task_recommendations = params[:dashboard][:product_ids]
      @dashboard.task_ids = params[:dashboard][:task_ids]
    else
      @dashboard.product_ids = []
      @dashboard.task_ids = []
    end
    redirect_to @dashboard
  end

  def destroy
    @recommendation = Recommendation.find(params[:id])
    @dashboard = @recommendation.dashboard
    @recommendation.delete
    flash[:notice] = 'Recommendation Removed'
    redirect_to @dashboard
  end

  def index
    @done_recommendations = Recommendation.includes("recommendable").done
    respond_to do |format|
      format.html { render 'index', layout: 'concierge' }
      format.csv { send_data @done_recommendations.to_csv }
    end
  end

  private

  def current_concierge_maybe
    if(!current_concierge.nil?)
      return current_concierge.id
    end
    return ''
  end

  def create_recommendation_params
    params.require(:recommendation).permit(:comment, :global_recommendable).merge(dashboard_id: @dashboard.id)
  end

  def update_recommendation_params
    params.require(:recommendation).permit(:comment)
  end

end