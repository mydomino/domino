class DashboardsController < ApplicationController
  helper_method :sort_column, :sort_direction
  # before_action :authenticate_concierge!, except: :show
  layout 'concierge', except: :show
  def index
    # @dashboards = Dashboard.all.page 1
    authorize Dashboard
    # if(params[:search].present?)
    #   @search_term = params[:search]
    #   @dashboards = Dashboard.all
    #   @dashboards = @dashboards.fuzzy_search(@search_term)
    #   @dashboards = Kaminari.paginate_array(@dashboards).page(1).per(20)
    #   return
    # else
    @page = params.has_key?(:page) ? params[:page] : 1
    # @dashboards = Kaminari.paginate_array(Dashboard.all).page(@page)
    # @dashboards = Dashboard.all
    @filter = params[:filter]
    if(@filter == 'all' || @filter == nil)
      @dashboards = Dashboard.all.order(sort_column + " " + sort_direction) 
      # @dashboards = Kaminari.paginate_array(Dashboard.all.order(sort_column + " " + sort_direction)).page(@page)
    else
    #   @filter = 'mine'
      @dashboards = Dashboard.where(concierge_id: current_user.id).order(sort_column + " " + sort_direction)
    end
    @dashboards = Kaminari.paginate_array(@dashboards).page(@page)

    #handle search
    # if(params[:search].present?)
    #   @search_term = params[:search]
    #   @dashboards = @dashboards.fuzzy_search(@search_term).paginate(:page => params[:page], :per_page => 50)
    # end
    # end
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
      authorize @dashboard, :show    
    end
    # if(@dashboard.nil?)
    #   not_found
    # end
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
    # respond_to do |format|
    #   format.html {render :layout => 'dashboard'}
    # end
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