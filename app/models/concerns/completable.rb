# app/models/concerns/completable.rb

module Completable
  extend ActiveSupport::Concern

  included do
    scope :completed, -> { where.not(completed_at: nil) }
  end

  class_methods do
    def completed_count
      where.not(completed_at: nil).count
    end
  end

  def complete!
    update(completed_at: Time.current)
  end

  def incomplete!
    update(completed_at: nil)
  end

  def completed?
    completed_at.present?
  end
end
