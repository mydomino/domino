class RecommendationsController < ApplicationController
  before_action :authenticate_user!, except: [:complete, :undo]
  layout 'concierge'

  def complete
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: true, updated_by: current_concierge_maybe)
    redirect_to @recommendation.dashboard
  end

  def undo
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.update_attributes(done: false)
    redirect_to @recommendation.dashboard
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

  def bulk_update
    @dashboard = Dashboard.find(params[:dashboard_id]);
    if(!params[:dashboard].nil?)
      new_product_recommendations = params[:dashboard][:product_ids]
      @dashboard.product_ids = params[:dashboard][:product_ids]
      new_task_recommendations = params[:dashboard][:product_ids]
      @dashboard.task_ids = params[:dashboard][:task_ids]
    else
      @dashboard.product_ids = []
      @dashboard.task_ids = []
    end
    redirect_to dashboard_path(@dashboard)
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
    return ''
  end

  def create_recommendation_params
    params.require(:recommendation).permit(:global_recommendable).merge(dashboard_id: @dashboard.id)
  end

end
