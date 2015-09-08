class TasksController < ApplicationController
  before_action :authenticate_concierge!
  layout 'concierge'

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to amazon_storefronts_path
    else
      render :new
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :icon_url)
  end

end