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

  after_create_commit do
    broadcast_prepend_to "projects", target: "projects", partial: "projects/project", locals: { project: self }
    broadcast_replace_to "results_in_header", target: "results_in_header",
                                              partial: "layouts/results_in_header"
  end
  after_update_commit do
    broadcast_replace_to self, partial: "projects/project", locals: { project: self }
    broadcast_replace_to "results_in_header", target: "results_in_header",
                                              partial: "layouts/results_in_header"
  end
  after_destroy_commit do
    broadcast_remove_to self
    broadcast_replace_to "results_in_header", target: "results_in_header",
                                              partial: "layouts/results_in_header"
  end

  has_one_attached :feature_image
end
