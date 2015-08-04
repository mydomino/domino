class PagesController < ApplicationController
  caches_page :about

  def index
    @lead = Lead.new
  end

  def about

  end

  def terms

  end

  def privacy

  end

  def signup
    @lead = FormSubmission.new(signup_params)
    @lead.save
    render :signup
  end

end
