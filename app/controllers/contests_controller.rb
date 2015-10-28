class ContestsController < ApplicationController
  before_action :authenticate_concierge!, except: :show
  layout 'concierge', except: :show

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
    @lead = Lead.new
  end

  private

  def contest_params
    params.require(:contest).permit(:name, :end_date)
  end
  
end