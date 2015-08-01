class PagesController < ApplicationController
  caches_page :about

  def index
  end

  def getstarted
    set_tracking_variables
  end

  def signup
    @lead = FormSubmission.new(signup_params)
    @lead.save
    render :signup
  end

end
