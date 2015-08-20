class LeadsController < ApplicationController
  http_basic_authenticate_with name: "domino", password: "danthepenguinstud", only: :index

  def index
    @leads = Lead.all
  end

  def new
    @lead = Lead.new
  end

  def create
    sleep(1)
    set_tracking_variables
    @lead = Lead.create(lead_params)
    @lead.last_name = "Not Given" if(@lead.last_name == '') 
    @lead.save
    render 'new_callback.js'
  end

  private

  def set_tracking_variables
    session[:ip]          ||= request.remote_ip
    session[:referer]     ||= request.referer
    session[:browser]     ||= request.user_agent
  end

  def lead_params
    params.require(:lead).permit(:first_name, :last_name, :email, :address, :phone).merge(session_params)
  end

  def session_params
    keys = %i(ip referer browser start_time campaign)
    keys.each_with_object({}) do |str, hsh|
      hsh[str] = session[str]
    end
  end
end