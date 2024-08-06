# == Schema Information
#
# Table name: projects
#
#  id           :bigint           not null, primary key
#  completed_at :datetime
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Project < ApplicationRecord
  include Completable
  validates :title, presence: true

  after_create_commit { broadcast_prepend_to 'projects', target: 'projects', partial: 'projects/project', locals: { project: self }}

  after_update_commit { broadcast_update_to "projects", target: "project_#{self.id}", partial: "projects/project", locals: { project: self } }

  after_destroy_commit { broadcast_remove_to "projects", target: "project_#{self.id}" }

  has_one_attached :feature_image
end
