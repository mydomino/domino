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
    @dashboard = Dashboard.friendly.find(params[:id])
    render layout: 'storefront'
  end

  def index
    @dashboards = Dashboard.where(concierge: current_concierge)
  end

  private

  def dashboard_params
    params.require(:dashboard).permit(:lead_name, :lead_email, :concierge_id, :recommendations_attributes => [:product_id])
  end

end