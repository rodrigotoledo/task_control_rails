# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id           :bigint           not null, primary key
#  completed_at :datetime
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class ProjectsController < ApplicationController
  before_action :set_project, only: %i[edit update destroy]

  # GET /projects
  def index
    @projects = Project.includes(:feature_image_attachment).order(created_at: :desc)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to projects_path, notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: 'Project was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy!
    redirect_to projects_path, alert: 'Project was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  rescue StandardError
    redirect_to projects_path
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:title, :completed_at, :feature_image)
  end
end
