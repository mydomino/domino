class DashboardsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  layout 'concierge', except: :show

  def index
    authorize Dashboard

    @page = params.has_key?(:page) ? params[:page] : 1

    @dashboards = Dashboard.all.order(sort_column + " " + sort_direction).page @page
    
    if(params.has_key? :search)
      @search_term = params[:search]
      @dashboards = @dashboards.fuzzy_search(@search_term).page @page
    end
  end

  def show
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

  def new
    @dashboard = Dashboard.new
  end

  def destroy
    @dashboard = Dashboard.find(params[:id])
    if lu = LegacyUser.find_by_email(@dashboard.lead_email)
      lu.destroy
    end

    if @dashboard.user_id
      User.find_by_id(@dashboard.user_id).destroy
      redirect_to dashboards_path and return
    else
      if profile = Profile.find_by_email(@dashboard.lead_email)
        profile.destroy
      end
      @dashboard.destroy
    end
    redirect_to dashboards_path and return
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