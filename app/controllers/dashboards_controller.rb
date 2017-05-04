class DashboardsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  after_action :verify_authorized

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
    if params.has_key? :id
      @dashboard = Dashboard.find(params[:id])
      @profile = Profile.find_by_email(@dashboard.lead_email)
    else
      @dashboard = Dashboard.find_by_user_id(current_user.id)
      @profile = current_user.profile
    end

    authorize @dashboard

    @welcome_message = @profile.first_name ? "Hi, #{@profile.first_name.capitalize}" : "Hello!"

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
    track_event "View dashboard"
    render :layout => 'dashboard'
  end

  def destroy
    @dashboard = Dashboard.find(params[:id])
    authorize @dashboard

    if @dashboard.user_id
      User.find_by_id(@dashboard.user_id).destroy
    else
      if profile = Profile.find_by_email(@dashboard.lead_email)
        profile.destroy
      end
      @dashboard.destroy
    end

    redirect_to dashboards_path
    return
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