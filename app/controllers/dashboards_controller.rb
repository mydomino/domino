class DashboardsController < ApplicationController
  before_action :authenticate_concierge!, except: :show
  layout 'concierge'

  def new
    @dashboard = Dashboard.new
    @concierges = Concierge.all
  end

  def create
    @dashboard = Dashboard.create(dashboard_params)
    @dashboard.concierge = current_concierge
    if @dashboard.save
      redirect_to @dashboard
    else
      render :new
    end
  end

  def show
    @dashboard = Dashboard.friendly.find(params[:id].downcase)
    @filter = params[:filter]
    if(@filter == 'products')
      @recommendations = @dashboard.recommendations.where(recommendable_type: "Product")
    elsif(@filter == 'actions')
      @recommendations = @dashboard.recommendations.where(recommendable_type: "Task")
    else
      @recommendations = @dashboard.recommendations
    end
    render layout: 'dashboard'
  end

  def index
    @dashboards = Dashboard.where(concierge: current_concierge)
  end

  def destroy
    @dashboard = Dashboard.friendly.find(params[:id])
    @dashboard.destroy

    redirect_to dashboards_path
  end

  private

  def dashboard_params
    params.require(:dashboard).permit(:lead_name, :lead_email, :concierge_id, :recommendations_attributes => [:product_id])
  end

end