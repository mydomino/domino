class LeadsController < ApplicationController
  http_basic_authenticate_with name: "domino", password: "danthepenguinstud", only: :index

  def index
    @leads = Lead.all
  end

  def new
    @lead = Lead.new
  end

  def energy_awareness
    @lead = Lead.new
  end

  def create
    set_tracking_variables
    @lead = Lead.create(lead_params)
    @lead.save
    if(params[:lead][:form_name] == 'energy_awareness_contest')
      @thank_you_text = "Your entry has been received! We'll be in touch soon!"
    else
      @thank_you_text = "We will be in touch soon!"
    end
    render 'new_callback.js'
  end

  private

  def set_tracking_variables
    session[:ip]          ||= request.remote_ip
    session[:referer]     ||= request.referer
    session[:browser]     ||= request.user_agent
  end

  def lead_params
    params.require(:lead).permit(:first_name, :last_name, :email, :address, :phone, :get_started_id, :subscribe_to_mailchimp).merge(session_params)
  end

  def session_params
    keys = %i(ip referer browser start_time campaign)
    keys.each_with_object({}) do |str, hsh|
      hsh[str] = session[str]
    end
  end
end
