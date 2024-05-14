require 'rails_helper'

RSpec.describe 'Api::Projects', type: :request do
  describe 'Projects Operations' do
    let(:valid_attributes) do
      attributes_for(:project)
    end

    let(:invalid_attributes) do
      { title: '' }
    end

    describe 'GET /projects' do
      it 'returns a list of projects in ascending order of creation' do
        create_list(:project, 5)

        get api_projects_path
        projects = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(projects.length).to eq(5)
      end

      it 'return feature image url' do
        project = build(:project)
        image_path = Rails.root.join('spec/fixtures/ruby_on_rails.png')
        project.feature_image.attach(io: File.open(image_path), filename: 'ruby_on_rails.png')
        project.save!

        get api_projects_path
        expect(json_response.first[:feature_image_url]).not_to be_empty
      end
    end

    describe 'PATCH /projects/:id/mark_as_completed' do
      it 'marks a project as completed' do
        project = create(:project)

        patch mark_as_completed_api_project_path(project.id)
        project.reload

        expect(response).to have_http_status(200)
        expect(project.completed_at).not_to be_nil
      end
    end

    describe 'POST /api/projects' do
      it 'creates a new project' do
        post api_projects_url, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.body).to include(valid_attributes[:title])
      end

      it 'error when try create a project' do
        post api_projects_url, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'PATCH /api/projects/:id' do
      let(:project) { create(:project) }

      it 'updates an existing project' do
        updated_title = 'Updated Title'
        patch api_project_url(project), params: { title: updated_title }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(updated_title)
      end

      it 'error when try update a project' do
        patch api_project_url(project), params: { title: '' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'GET /api/projects/:id' do
      let(:project) { create(:project) }

      it 'returns a specific project' do
        get api_project_url(project)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(project.title)
      end
    end

    describe 'DELETE /api/projects/:id' do
      let(:project) { create(:project) }

      it 'deletes a project' do
        delete api_project_url(project)
        expect(response).to have_http_status(:ok)
        expect(Project.exists?(project.id)).to be_falsey
      end
    end
  end
end
