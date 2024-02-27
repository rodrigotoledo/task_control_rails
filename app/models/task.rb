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
  validates :title, presence: true

  broadcasts_refreshes
  after_create :broadcast_create

  has_one_attached :feature_image

  private

  def broadcast_create
    broadcast_prepend_to self, target: 'tasks', partial: 'tasks/task', locals: { task: self }
  end

  def feature_image_url
    return unless feature_image.attached?

    Rails.application.routes.url_helpers.rails_blob_url(feature_image, only_path: true)
  end
end
