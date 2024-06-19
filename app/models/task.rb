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
    broadcast_prepend_to 'tasks', target: 'tasks', partial: 'tasks/task', locals: { task: self }
  end
  broadcasts_refreshes

  has_one_attached :feature_image
end
