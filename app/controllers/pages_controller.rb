class PagesController < ApplicationController
  skip_after_action :verify_authorized
  def index
    @profile = Profile.new
    @response = {form: 'profiles/name_and_email', method: :post}
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def team
  end

end
