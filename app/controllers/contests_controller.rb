class ContestsController < ApplicationController
  before_action :authenticate_concierge!, except: :show
  layout 'concierge', except: :show

  def index
    @contests = Contest.all
  end

  def new
    @contest = Contest.new
  end

  def create
    @contest = Contest.new(contest_params)
    if @contest.save
      redirect_to @contest
    else
      render :new
    end
  end

  def show
    @contest = Contest.friendly.find(params[:id])
    @lead = Lead.new
    if(@contest.end_date.past?)
      redirect_to new_lead_path
    end
  end

  private

  def contest_params
    params.require(:contest).permit(:name, :end_date, :start_date)
  end
  
end