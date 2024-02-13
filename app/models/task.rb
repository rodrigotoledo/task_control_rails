class Task < ApplicationRecord
  validates :title, presence: true

  broadcasts_refreshes
  after_create :broadcast_create
  private

  def broadcast_create
    broadcast_prepend_to self, target: "tasks", partial: "tasks/task", locals: { task: self }
  end
end
