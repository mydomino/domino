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
      #check if profile_step is in session
      # @user = User.new
      session[:profile_step] = 0
    end
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

  # def mydomino_updated
  #   @db = Dashboard.find_by_slug(params[:slug])
  #   if @db
  #     UserMailer.legacy_user_registration_email(@db.lead_email).deliver_later
  #   else
  #     redirect_to root_path
  #   end
  # end
end
