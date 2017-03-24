class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:membership]
  skip_after_action :verify_authorized
  layout 'example', only: :example

  def index
    # If user goes back to homepage from wizard form
    # Ensure that the form state is rendered properly
    if params.has_key?(:profile_id) && @profile = Profile.find(params[:profile_id])
      @response = {form: 'profiles/name_and_email', method: :put}
    else
      @profile = Profile.new
      @response = {form: 'profiles/name_and_email', method: :post}
    end
  end

  def about
    track_event "Pages - about"
  end

  def terms
    track_event "Pages - terms"
  end

  def privacy
    track_event "Pages - privacy"
  end

  def team
    track_event "Pages - team"
  end

  def faq
    track_event "Pages - faq"
  end

  def example
    track_event "Pages - example"
  end

  def partners
    track_event "Pages - partners"
  end

  def fat_d3
    track_event "Pages - fat_d3"
    
  end

  def newsletter_subscribe
    unless params[:email] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      @message = "Invalid email format."
    else
      SubscribeToMailchimpJob.perform_later params[:email]
      @message = "Thanks for signing up!"
    end

    track_event "subscribe newsletter"

    respond_to do |format|
      format.js
    end
  end

  private

  def interest_form_resources
    @active_inputs = @profile.interests.map {|i| i.offering_id }
    @offerings = Offering.all.map {|o| o.name }
  end

  def get_partner_code
    @partner_code = PartnerCode.find_by_id(@profile.partner_code_id)
  end

end
