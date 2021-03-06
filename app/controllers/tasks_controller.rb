class TasksController < ApplicationController
  # before_action :authenticate_concierge!
  layout 'concierge'

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path
    else
      render :new
    end
  end

  def index
    authorize Task
    @default_tasks = Task.where(default: true)
    @non_default_tasks = Task.where(default: false)
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      redirect_to tasks_path
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.delete
    redirect_to tasks_path
  end

  def toggle_default
    @task = Task.find(params[:task_id])
    @task.default = !@task.default
    @task.save
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :icon, :cta_link, :cta_text)
  end

end