# frozen_string_literal: true

module Api
  class ProjectsController < ActionController::API
    def index
      projects = Project.includes(:feature_image_attachment).order(updated_at: :desc)
      render json: projects.as_json(methods: :feature_image_url)
    end

    def update
      project = Project.find(params[:id])
      project.update(completed_at: Time.zone.now)
      head :ok
    end
  end
end
