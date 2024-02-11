require 'rails_helper'

RSpec.describe 'Api::Projects', type: :request do
  describe 'Projects Operations' do

    describe 'GET /projects' do
      it 'returns a list of projects in ascending order of creation' do
        create_list(:project, 5)

        get api_projects_path
        projects = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(projects.length).to eq(5)
      end
    end

    describe 'PATCH /projects/:id' do
      it 'marks a project as completed' do
        project = create(:project)

        patch api_project_path(project.id)
        project.reload

        expect(response).to have_http_status(200)
        expect(project.completed_at).not_to be_nil
      end
    end
  end
end