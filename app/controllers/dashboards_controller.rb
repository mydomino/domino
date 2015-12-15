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
    @dashboard.product_ids = Product.where(default: true).ids
    @dashboard.task_ids = Task.where(default: true).ids
    if @dashboard.save
      redirect_to @dashboard
    else
      render :new
    end
  end

  def show
    @dashboard = Dashboard.find_by_slug(params[:id].downcase)
    @filter = params[:filter]
    if(@filter == 'products')
      @recommendations = @dashboard.recommendations.where(recommendable_type: "Product").includes(:recommendable)
    elsif(@filter == 'actions')
      @recommendations = @dashboard.recommendations.where(recommendable_type: "Task").includes(:recommendable)
    else
      @recommendations = @dashboard.recommendations
    end
    render layout: 'dashboard'
  end

  def index
    @filter = params[:filter]
    if(@filter == 'all')
      @dashboards = Dashboard.all.paginate(:page => params[:page], :per_page => 16)
    else
      @filter = 'mine'
      @dashboards = Dashboard.where(concierge: current_concierge).paginate(:page => params[:page], :per_page => 16).includes(:recommendations)
    end
    #handle search
    if(params[:search].present?)
      @search_term = params[:search]
      @dashboards = @dashboards.basic_search(@search_term).paginate(:page => params[:page], :per_page => 16)
    end
    if(params[:view] == 'table')
      render 'table_index'
    else
      render 'index'
    end
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