class DashboardsController < ApplicationController

  helper_method :sort_column, :sort_direction
  # before_action :authenticate_concierge!, except: :show
  layout 'concierge', except: :show

  def index
    authorize Dashboard
    @page = params.has_key?(:page) ? params[:page] : 1
    @filter = params[:filter]

    if(@filter == 'all' || @filter == nil)
      @dashboards = Dashboard.all.order(sort_column + " " + sort_direction).page @page
      @filter = 'all'
    else
      @dashboards = Dashboard.where(concierge_id: current_user.id).order(sort_column + " " + sort_direction).page @page
    end

    if(params.has_key? :search)
      @search_term = params[:search]
      @dashboards = @dashboards.fuzzy_search(@search_term).page @page
    end
  end

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
    # @dashboard = Dashboard.find_by_slug(params[:id].downcase)
    if !user_signed_in?
      #set flash message to please sign in to access dashboard
      redirect_to new_user_session_path
      return
    else
      if params.has_key? :id
        @dashboard = Dashboard.find(params[:id])
      else
        @dashboard = Dashboard.find_by_user_id(current_user.id)
      end
      authorize @dashboard   
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
    render :layout => 'dashboard'
  end

 

  def destroy
    @dashboard = Dashboard.friendly.find(params[:id])
    @dashboard.destroy

    redirect_to dashboards_path
  end

  private

  def sort_column
    Dashboard.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
  def dashboard_params
    params.require(:dashboard).permit(:lead_name, :lead_email, :concierge_id)
  end

end