# frozen_string_literal: true

module Api
  class ProjectsController < ActionController::API
    before_action :set_project, only: %i[show update destroy mark_as_completed]
    include HasImageUrl
    def index
      projects = Project.includes(:feature_image_attachment).order(created_at: :desc)
      projects = projects.map do |project|
        with_image_url(project, :feature_image)
      end
      render json: projects
    end

    def create
      project = Project.new(project_params)

      if project.save
        render json: project, status: :created
      else
        render json: project.errors.to_json, status: :unprocessable_entity
      end
    end

    def update
      if @project.update(project_params)
        render json: @project, status: :ok
      else
        render json: @project.errors.to_json, status: :unprocessable_entity
      end
    end

    def show
      @project = with_image_url(@project, :feature_image)
      render json: @project, status: :ok
    end

    def destroy
      @project.destroy
      head :ok
    end

    def mark_as_completed
      @project.completed_at = Time.zone.now
      @project.save
      head :ok
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.except(:id).permit(:title, :completed_at, :feature_image)
    end
  end
end
