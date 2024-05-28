# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id           :bigint           not null, primary key
#  completed_at :datetime
#  scheduled_at :datetime
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy]

  # GET /tasks
  def index
    @tasks = Task.includes(:feature_image_attachment).order(created_at: :desc)
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_url, notice: 'Task was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: 'Task was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy!
    redirect_to tasks_url, alert: 'Task was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  rescue StandardError
    redirect_to tasks_path
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :scheduled_at, :completed_at, :feature_image)
  end
end
