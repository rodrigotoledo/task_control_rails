# frozen_string_literal: true

module Api
  class TasksController < ActionController::API
    before_action :set_task, only: %i[show update destroy mark_as_completed mark_as_incompleted]
    include HasImageUrl
    def index
      tasks = Task.includes(:feature_image_attachment).order(created_at: :desc)
      tasks = tasks.where('title ILIKE ?', "%#{params[:query]}%") if params[:query].present?
      tasks = tasks.map do |task|
        with_image_url(task, :feature_image)
      end
      render json: tasks
    end

    def create
      task = Task.new(task_params)

      if task.save
        render json: task, status: :created
      else
        render json: task.errors.to_json, status: :unprocessable_entity
      end
    end

    def update
      if @task.update(task_params)
        render json: @task, status: :ok
      else
        render json: @task.errors.to_json, status: :unprocessable_entity
      end
    end

    def show
      @task = with_image_url(@task, :feature_image)
      render json: @task, status: :ok
    end

    def destroy
      @task.destroy
      head :ok
    end

    def mark_as_completed
      @task.completed_at = Time.zone.now
      @task.save
      head :ok
    end

    def mark_as_incompleted
      @task.completed_at = nil
      @task.save
      head :ok
    end

    private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.except(:id).permit(:title, :scheduled_at, :completed_at, :feature_image)
    end
  end
end
