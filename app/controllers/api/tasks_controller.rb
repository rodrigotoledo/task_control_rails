# frozen_string_literal: true

module Api
  class TasksController < ActionController::API
    def index
      tasks = Task.includes(:feature_image_attachment).order(updated_at: :desc)
      render json: tasks.as_json(methods: :feature_image_url)
    end

    def update
      task = Task.find(params[:id])
      task.update(completed_at: Time.zone.now)
      head :ok
    end
  end
end
