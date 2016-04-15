class PagesController < ApplicationController
  # caches_action :index, :about, :terms, :privacy, :solar
  skip_after_action :verify_authorized
  def index
    @profile = Profile.new
    @response = {form: 'name_and_email', method: :post}
    #check if profile_step is in session
    # @user = User.new
    session[:profile_step] = 0
  end

  def about

  end

  def terms

  end

  def privacy

  end

  def solar
    @lead = Lead.new
  end

end
