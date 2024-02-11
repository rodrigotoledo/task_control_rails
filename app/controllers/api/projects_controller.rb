class Api::ProjectsController < ActionController::API
  def index
    projects = Project.order(created_at: :asc)
    render json: projects.all
  end

  def update
    project = Project.find(params[:id])
    project.update(completed_at: Time.now)
    head :ok
  end
end