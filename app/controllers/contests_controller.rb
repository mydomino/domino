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
      redirect_to root_path
    end
  end

  def edit
    @contest = Contest.friendly.find(params[:id])
  end

  def update
    @contest = Contest.friendly.find(params[:id])
    if(@contest.update_attributes(contest_params))
      redirect_to @contest
    else
      render :edit
    end
  end

  private

  def contest_params
    params.require(:contest).permit(:name, :end_date, :start_date, :headline)
  end
  
end