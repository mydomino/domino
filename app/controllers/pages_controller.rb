class PagesController < ApplicationController
  # caches_action :index, :about, :terms, :privacy, :solar
  skip_after_action :verify_authorized
  def index
    if params[:slug]
      @email = Dashboard.find_by_slug(params[:slug]).lead_email
      @lu = LegacyUser.find_by_email(@email)
      UserMailer.legacy_user_registration_email(@email).deliver_later
      @response = {form: 'profiles/mydomino_updated'}
    else
      @profile = Profile.new
      @response = {form: 'profiles/name_and_email', method: :post}
    end
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
