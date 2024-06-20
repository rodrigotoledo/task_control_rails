require 'rails_helper'

RSpec.describe 'Api::Tasks', type: :request do
  describe 'Tasks Operations' do
    let(:valid_attributes) do
      attributes_for(:task)
    end

    let(:invalid_attributes) do
      { title: '' }
    end

    describe 'GET /tasks' do
      it 'returns a list of tasks in ascending order of creation' do
        create_list(:task, 5)
        get api_tasks_path
        tasks = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(tasks.length).to eq(5)
      end

      it 'return feature image url' do
        task = build(:task)
        image_path = Rails.root.join('spec/fixtures/ruby_on_rails.png')
        task.feature_image.attach(io: File.open(image_path), filename: 'ruby_on_rails.png')
        task.save!

        get api_tasks_path
        expect(json_response.first[:feature_image_url]).not_to be_nil
      end
    end

    describe 'PATCH /tasks/:id/mark_as_completed' do
      it 'marks a task as completed' do
        task = create(:task)

        patch mark_as_completed_api_task_path(task.id)
        task.reload

        expect(response).to have_http_status(200)
        expect(task.completed_at).not_to be_nil
      end
    end

    describe 'PATCH /tasks/:id/mark_as_incompleted' do
      it 'marks a task as completed' do
        task = create(:task, completed_at: Time.zone.now)

        patch mark_as_incompleted_api_task_path(task.id)
        task.reload

        expect(response).to have_http_status(200)
        expect(task.completed_at).to be_nil
      end
    end

    describe 'POST /api/tasks' do
      it 'creates a new task' do
        post api_tasks_url, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.body).to include(valid_attributes[:title])
      end

      it 'error when try create a task' do
        post api_tasks_url, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'PATCH /api/tasks/:id' do
      let(:task) { create(:task) }

      it 'updates an existing task' do
        updated_title = 'Updated Title'
        patch api_task_url(task), params: { title: updated_title }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(updated_title)
      end

      it 'error when try update a task' do
        patch api_task_url(task), params: { title: '' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'GET /api/tasks/:id' do
      let(:task) { create(:task) }

      it 'returns a specific task' do
        get api_task_url(task)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(task.title)
      end
    end

    describe 'DELETE /api/tasks/:id' do
      let(:task) { create(:task) }

      it 'deletes a task' do
        delete api_task_url(task)
        expect(response).to have_http_status(:ok)
        expect(Project.exists?(task.id)).to be_falsey
      end
    end
  end
end
