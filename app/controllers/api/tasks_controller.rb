class Api::TasksController < ActionController::API
  def index
    tasks = Task.order(scheduled_at: :asc)
    render json: tasks.all
  end

  def update
    task = Task.find(params[:id])
    task.update(completed_at: Time.now)
    head :ok
  end
end