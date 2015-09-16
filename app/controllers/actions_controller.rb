class ActionsController < ApplicationController
  before_action :authenticate_concierge!
  layout 'concierge'

  def new
    @action = Action.new
  end

  def create
    @action = Action.new(action_params)
    if @action.save
      redirect_to actions_path
    else
      render :new
    end
  end

  def index
    @actions = Action.all
  end

  def edit
    @action = Action.find(params[:id])
  end

  def update
    @action = Action.find(params[:id])
    if @action.update_attributes(action_params)
      redirect_to actions_path
    else
      render :edit
    end
  end

  def destroy
    @action = Action.find(params[:id])
    @action.delete
    redirect_to actions_path
  end

  private

  def action_params
    params.require(:action).permit(:name, :description, :icon)
  end

end