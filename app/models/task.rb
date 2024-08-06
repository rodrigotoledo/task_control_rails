# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id           :bigint           not null, primary key
#  completed_at :datetime
#  scheduled_at :datetime
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Task < ApplicationRecord
  include Completable
  validates :title, presence: true

  after_create_commit { broadcast_prepend_to 'tasks', target: 'tasks', partial: 'tasks/task', locals: { task: self }}

  after_update_commit { broadcast_update_to "tasks", target: "task_#{self.id}", partial: "tasks/task", locals: { task: self } }

  after_destroy_commit { broadcast_remove_to "tasks", target: "task_#{self.id}" }

  has_one_attached :feature_image
end
