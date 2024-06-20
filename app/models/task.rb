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

  after_create_commit do
    broadcast_prepend_to "tasks", target: "tasks", partial: "tasks/task", locals: { task: self }
    broadcast_update_to "results_in_header", target: "results_in_header",
                                              partial: "layouts/results_in_header"
  end
  after_update_commit do
    broadcast_replace_to self, partial: "tasks/task", locals: { task: self }
    broadcast_update_to "results_in_header", target: "results_in_header",
                                              partial: "layouts/results_in_header"
  end
  after_destroy_commit do
    broadcast_remove_to self
    broadcast_update_to "results_in_header", target: "results_in_header",
                                              partial: "layouts/results_in_header"
  end

  has_one_attached :feature_image
end
