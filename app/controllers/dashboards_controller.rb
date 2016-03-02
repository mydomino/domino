class DashboardsController < ApplicationController
  before_action :authenticate_concierge!, except: :show
  layout 'concierge', except: :show

  def new
    @dashboard = Dashboard.new
  end

  def create
    @dashboard = Dashboard.create(dashboard_params)
    @dashboard.concierge = current_concierge
    @dashboard.products = Product.default
    @dashboard.tasks = Task.default
    if @dashboard.save
      redirect_to @dashboard
    else
      render :new
    end
  end

  def show
    @dashboard = Dashboard.find_by_slug(params[:id].downcase)
    if(@dashboard.nil?)
      not_found
    end
    @products = Product.all
    @tasks = Task.all
    @filter = params[:filter]
    if(@filter == 'products')
      @completed_recommendations = @dashboard.recommendations.done.where(recommendable_type: "Product").includes(:recommendable)
      @incomplete_recommendations = @dashboard.recommendations.incomplete.where(recommendable_type: "Product").includes(:recommendable)
    elsif(@filter == 'actions')
      @completed_recommendations = @dashboard.recommendations.done.where(recommendable_type: "Task").includes(:recommendable)
      @incomplete_recommendations = @dashboard.recommendations.incomplete.where(recommendable_type: "Task").includes(:recommendable)
    else
      @completed_recommendations = @dashboard.recommendations.done.includes(:recommendable)
      @incomplete_recommendations = @dashboard.recommendations.incomplete.includes(:recommendable)
    end
    respond_to do |format|
      format.html {render :layout => 'dashboard'}
    end
  end

  def index
    @filter = params[:filter]
    if(@filter == 'all')
      @dashboards = Dashboard.all.paginate(:page => params[:page], :per_page => 16)
    else
      @filter = 'mine'
      @dashboards = Dashboard.where(concierge: current_concierge).paginate(:page => params[:page], :per_page => 16)
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
    params.require(:dashboard).permit(:lead_name, :lead_email, :concierge_id)
  end

end