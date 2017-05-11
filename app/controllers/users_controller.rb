class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!

  def beta_index
    @page = params.has_key?(:page) ? params[:page] : 1

    beta_group = Group.find_by_name('beta')
    @users = beta_group.users.includes(:profile).order(sort_column + " " + sort_direction).page @page
    # @dashboards = Dashboard.all.order(sort_column + " " + sort_direction).page @page
    
    if(params.has_key? :search)
      @search_term = params[:search]
      @users = @users.fuzzy_search(@search_term).page @page
    end
   
  end

  private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
