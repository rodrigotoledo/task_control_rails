class Project < ApplicationRecord
  validates :title, presence: true

  broadcasts_refreshes
  after_create :broadcast_create
  private

  def broadcast_create
    broadcast_prepend_to self, target: "projects", partial: "projects/project", locals: { project: self }
  end
end
